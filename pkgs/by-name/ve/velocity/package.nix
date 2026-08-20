{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_9,
  jdk25,
  makeBinaryWrapper,
  openssl,
  libdeflate,
  jdk25_headless,
  writeScript,
  nixosTests,

  # native (openssl + libdeflate) compression and crypto implementations
  withVelocityNative ? builtins.elem stdenv.hostPlatform.system [
    "x86_64-linux"
    "aarch64-linux"
  ],
}:
let
  velocityNativePlatform =
    {
      x86_64-linux = "linux_x86_64";
      aarch64-linux = "linux_aarch64";
    }
    .${stdenv.hostPlatform.system} or (
      if withVelocityNative then
        throw "velocity native is not supported on ${stdenv.hostPlatform.system}"
      else
        null
    );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "velocity";
  version = "4.1.0-unstable-2026-08-14";

  src = fetchFromGitHub {
    owner = "PaperMC";
    repo = "Velocity";
    rev = "4772ca3022c49bfab37c703f72cbca7654fb5848";
    hash = "sha256-uz6C7VmlAAd63zt+n1FkU3m05GT5ciwT7dYVne/DFYA=";
  };

  nativeBuildInputs = [
    gradle_9
    makeBinaryWrapper
  ];

  buildInputs = lib.optionals withVelocityNative [
    # libraries for velocity-native
    openssl
    libdeflate

    # needed for building velocity-native jni
    jdk25
  ];

  strictDeps = true;

  mitmCache = gradle_9.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  gradleUpdateScript = ''
    runHook preBuild

    gradle --write-verification-metadata sha256
  '';

  patches = [
    ./fix-version.patch # remove build-time dependency on git and use version string from a env var instead
    ./disable-javadocs.patch # disable building java docs because they cause build failures
  ];

  # tests require velocity native
  doCheck = withVelocityNative;

  postPatch = ''
    rm -rf native/src/main/resources/{linux_x86_64,linux_aarch64,macos_aarch64}/*
  '';

  # based on native/build-support/compile-linux-{compress,crypt}.sh
  preBuild =
    let
      CFLAGS = "-O2 -fPIC -shared -Wl,-z,noexecstack -Wall -Werror -fomit-frame-pointer";
    in
    lib.optionalString withVelocityNative ''
      $CC ${CFLAGS} native/src/main/c/jni_util.c native/src/main/c/jni_cipher_openssl.c \
        -o native/src/main/resources/${velocityNativePlatform}/velocity-cipher-ossl30x.so \
        -lcrypto

      $CC ${CFLAGS} native/src/main/c/jni_util.c native/src/main/c/jni_zlib_deflate.c native/src/main/c/jni_zlib_inflate.c \
        -o native/src/main/resources/${velocityNativePlatform}/velocity-compress.so \
        -ldeflate
    '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/velocity
    cp proxy/build/libs/velocity-proxy-${builtins.head (builtins.split "-" finalAttrs.version)}-SNAPSHOT-all.jar $out/share/velocity/velocity.jar

    makeWrapper ${lib.getExe jdk25_headless} "$out/bin/velocity" \
      --append-flags "-jar $out/share/velocity/velocity.jar"

    ${lib.optionalString withVelocityNative ''
      # Nix doesn't pick up references in compressed JAR file
      mkdir $out/nix-support
      echo ${lib.getLib openssl} >> $out/nix-support/runtime-dependencies
      echo ${lib.getLib libdeflate} >> $out/nix-support/runtime-dependencies
    ''}

    runHook postInstall
  '';

  env.BUILD_VERSION = "nixpkgs-${finalAttrs.version}";

  passthru = {
    updateScript = writeScript "update-velocity" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts

      tmpdir="$(mktemp -d)"
      git clone --depth=1 "${finalAttrs.src.gitRepoUrl}" "$tmpdir"

      pushd "$tmpdir"

      main_version=$(awk 'match($0,/version=([0-9.]+)/,r) { print r[1] }' gradle.properties)
      commit_date=$(git show -s --pretty='format:%cs')
      commit_hash=$(git show -s --pretty='format:%H')

      popd
      rm -rf "$tmpdir"

      update-source-version "$UPDATE_NIX_ATTR_PATH" "$main_version-unstable-$commit_date" --rev="$commit_hash"
      $(nix-build -A velocity.mitmCache.updateScript)
    '';
    tests.velocity = nixosTests.velocity;
  };

  meta = {
    description = "Modern, next-generation Minecraft server proxy";
    homepage = "https://papermc.io/software/velocity";
    license = with lib.licenses; [
      gpl3Only
      mit
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # java deps
    ];
    maintainers = with lib.maintainers; [ Tert0 ];
    platforms = lib.platforms.linux;
    mainProgram = "velocity";
  };
})
