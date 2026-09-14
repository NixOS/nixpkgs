{
  lib,
  fetchFromGitHub,
  getopt,
  stdenv,
  swift,
  swiftpm,
  swiftPackages,
  versionCheckHook,
  xz, # liblzma
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unxip";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "saagarjha";
    repo = "unxip";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GpiJ4F+VMrVSgNACMuCTixWd32eco3eaSKZotP4INT8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    zlib
    xz
    getopt
    swiftPackages.Foundation
  ];

  installPhase = ''
    runHook preInstall

    binPath="$(swiftpmBinPath)"
    mkdir -p $out/bin
    cp $binPath/unxip $out/bin/

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  __structuredAttrs = true;

  meta = {
    description = "Fast Xcode unarchiver";
    homepage = "https://github.com/saagarjha/unxip";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ DimitarNestorov ];
    mainProgram = "unxip";
  };
})
