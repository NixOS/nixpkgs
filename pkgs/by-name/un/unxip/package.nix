{
  lib,
  fetchFromGitHub,
  getopt,
  stdenv,
  swift,
  swiftpm,
  versionCheckHook,
  xz, # liblzma
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unxip";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "saagarjha";
    repo = "unxip";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+DYqb4Y2jqWEMungO+rE1UzMXLuAWAzsx6s0mbtOkR4=";
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
