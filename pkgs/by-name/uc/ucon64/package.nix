{
  lib,
  stdenv,
  fetchurl,
  versionCheckHook,
  libusb1,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ucon64";
  version = "2.2.2";

  src = fetchurl {
    url = "https://sourceforge.net/projects/ucon64/files/ucon64/ucon64-${finalAttrs.version}/ucon64-${finalAttrs.version}-src.tar.gz/download";
    name = "ucon64-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-4QCtSjD2wZq96Y42HGoOysTkBHf1TPt1SYxczSH7Ohg=";
  };

  buildInputs = [
    zlib
    libusb1
  ];

  sourceRoot = "ucon64-${finalAttrs.version}-src/src";

  # Disable parallel on ARM (sys/io.h is x86-only)
  configureFlags = lib.optionals (!stdenv.hostPlatform.isx86) [
    "--disable-parallel"
  ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 ucon64 -t $out/bin/

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Tool to backup video game cartridges and perform various ROM operations";
    homepage = "https://ucon64.sourceforge.io/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "ucon64";
  };
})
