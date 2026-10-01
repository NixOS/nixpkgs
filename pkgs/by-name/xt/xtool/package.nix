{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchSwiftPMDeps,
  gnutar,
  jq,
  makeWrapper,
  swift,
  swiftpm,
  pkg-config,
  libimobiledevice,
  libimobiledevice-glue,
  libplist,
  libusbmuxd,
  openssl,
  unzip,
  versionCheckHook,
  xadi,
  xz,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xtool";
  version = "1.20.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "xtool-org";
    repo = "xtool";
    tag = finalAttrs.version;
    hash = "sha256-OAY8BnhHA0CHWA33TsZ9jJcvmmJvfLNNKQrGmuZNGd0=";
  };

  patches = [
    # TODO: https://github.com/xtool-org/xtool/issues/286
    # combine-schedulers declares OpenCombine, which upstream's Package.resolved doesn't pin
    ./pin-opencombine.patch
  ];

  swiftpmDeps = fetchSwiftPMDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      ;
    hash = "sha256-7tZUYQc/pqUuuDSwZxSNVwO0l0AQit+AAEdB2zyRme4=";
  };

  nativeBuildInputs = [
    jq
    makeWrapper
    pkg-config
    swift
    swiftpm
  ];

  buildInputs = [
    libimobiledevice
    libimobiledevice-glue
    libplist
    libusbmuxd
    openssl
    xz
    zlib
  ];

  env.XTOOL_VERSION = finalAttrs.version;

  postPatch = ''
    pinned=$(jq -r '.pins[] | select(.identity == "xadi") | .state.version' Package.resolved)
    if [ "$pinned" != "${xadi.version}" ]; then
      echo "xadi ${xadi.version} doesn't match the version xtool pins ($pinned)" >&2
      exit 1
    fi

    # use the nixpkgs xadi build instead of downloading the artifact bundle
    rm Packages
    mkdir Packages
    ln -s "$swiftpmDeps"/Packages/* Packages/
    rm Packages/xadi
    cp -r --no-preserve=mode "$swiftpmDeps"/Packages/xadi Packages/xadi
    ln -s ${xadi}/lib/XADIBinary.artifactbundle Packages/xadi/XADIBinary.artifactbundle
    substituteInPlace Packages/xadi/Package.swift \
      --replace-fail \
        'url: "https://github.com/xtool-org/xadi/releases/download/source-${xadi.version}/XADIBinary.artifactbundle.zip",' \
        'path: "XADIBinary.artifactbundle"'
    sed -i '/checksum: "/d' Packages/xadi/Package.swift

    # TODO: https://github.com/NixOS/nixpkgs/pull/565702
    # Test.cancel needs Swift 6.3
    rm Tests/XToolTests/{RequiresXcodeTrait,XcodeTests}.swift
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # use the nixpkgs libraries instead of downloading prebuilt xcframeworks
    rm Packages/xtool-core
    cp -r --no-preserve=mode "$swiftpmDeps"/Packages/xtool-core Packages/xtool-core
    substituteInPlace Packages/xtool-core/Package.swift \
      --replace-fail '#if os(Linux) || os(Windows) || os(Android)' '#if os(Linux) || os(Windows) || os(Android) || os(macOS)'
  '';

  # swift test needs Xcode's XCTest on macOS
  doCheck = !stdenv.hostPlatform.isDarwin;

  postInstall = ''
    # libXADI comes from the xadi dependency, which swiftpmInstallPhase doesn't install
    install -Dm644 "$(swiftpmBinPath)/libXADI${stdenv.hostPlatform.extensions.sharedLibrary}" -t "$out/lib"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath "$out/lib" "$out/bin/xtool"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -add_rpath "$out/lib" "$out/bin/xtool"
  ''
  + ''
    # xtool calls tar and unzip at runtime
    wrapProgram "$out/bin/xtool" \
      --suffix PATH : ${
        lib.makeBinPath [
          gnutar
          unzip
        ]
      }
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Cross-platform Xcode replacement";
    homepage = "https://xtool.sh";
    changelog = "https://github.com/xtool-org/xtool/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anish ];
    mainProgram = "xtool";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
