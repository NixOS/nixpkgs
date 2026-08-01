{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,

  # build-time
  cmake,
  xxd,
  which,

  # run-time
  readline,

  # tests
  callPackage,
  jq,
  meson,
  ninja,
}:

let
  inherit (stdenv.hostPlatform)
    isDarwin
    isLinux
    isMusl
    isUnix
    ;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "zenroom";
  version = "5.37.2";

  src = fetchFromGitHub {
    owner = "dyne";
    repo = "Zenroom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gNUclaXF7C2yBywo1TAwHOfB9Pe17g6fCLhEcFq8JL0=";
    postFetch = ''
      # conflict on case-insensitive filesystems
      pushd $out/docs/examples/zencode_cookbook/cookbook_when
      rm *_move_as.out.json *_move_to.out.json
      popd
    '';
  };

  postPatch = ''
    patchShebangs build/{embed-lualibs,meson_version.sh}
    patchShebangs test/
  '';

  __structuredAttrs = true;
  strictDeps = true;

  # cmake is required to build dependencies, not the main package
  dontUseCmakeConfigure = true;

  # manually invoken while testing
  dontUseMesonConfigure = true;
  dontUseNinjaBuild = true;
  dontUseNinjaCheck = true;
  dontUseNinjaInstall = true;

  nativeBuildInputs = [
    cmake
    which # ar
    xxd
  ];

  buildInputs = [
    readline
  ];

  buildFlags = [
    "VERSION=${finalAttrs.version}"
    "COMMIT=0000000"
    "BRANCH=master"
    "CURRENT_YEAR=1970" # unix epoch
  ]
  ++ lib.optionals (isLinux && !isMusl) [
    "linux-lib"
    "linux-exe"
  ]
  ++ lib.optionals (isLinux && isMusl) [
    "musl"
  ]
  ++ lib.optionals isDarwin [
    "osx-lib"
    "osx-exe"
  ]
  ++ lib.optionals (isUnix && !isLinux && !isDarwin) [
    "posix-lib"
    "posix-exe"
  ];

  hardeningDisable = [ "format" ]; # -Werror=format-security

  env.PREFIX = "";
  env.DESTDIR = placeholder "out";

  preInstall = ''
    mkdir -p $out/{bin,share}
  '';

  postInstall = ''
    install -D libzenroom${stdenv.hostPlatform.extensions.sharedLibrary} -t $out/lib
  '';

  nativeCheckInputs = [
    jq
    meson
    ninja
  ];

  doCheck = true;
  checkTarget = "check" + lib.optionalString isDarwin "-osx";

  preCheck =
    lib.optionalString isDarwin # sh
      ''
        # on darwin, we're using GNU base64
        substituteInPlace test/zencode/cookbook_{hash_pdf,ecdh_encrypt_json}.bats \
          --replace-fail \
            'cmd_base64="base64 -b 0"' \
            'cmd_base64="base64 -w 0"'
      '';

  passthru.updateScript = nix-update-script { };
  passthru.tests = callPackage ./tests { zenroom = finalAttrs.finalPackage; };

  meta = {
    description = "No-code cryptographic virtual machine";
    longDescription = ''
      Zenroom is a tiny, portable, and fully isolated crypto VM for building
      privacy-preserving applications, smart contracts, and secure data
      workflows.
    '';
    homepage = "https://github.com/dyne/Zenroom";
    changelog = "https://github.com/dyne/Zenroom/blob/${finalAttrs.src.rev}/ChangeLog.md";
    mainProgram = "zenroom";
    platforms = lib.platforms.unix;
    license = with lib.licenses; [
      agpl3Plus
      asl20 # lib/milagro-crypto-c, lib/mlkem, lib/longfellow-zk, lib/mayo
      bsd3 # lib/zstd
      cc0 # lib/pqclean, lib/ed25519-donna
      mit # lib/lua54, src/varint.*, lib/mayo
    ];
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
