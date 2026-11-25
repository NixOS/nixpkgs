{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wla-dx";
  version = "10.8";

  src = fetchFromGitHub {
    owner = "vhelin";
    repo = "wla-dx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xdb6zXJvgdd+mjmO6J19dvf7VDd0W4y0ifGcSGPNT6A=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install binaries/* $out/bin

    runHook postInstall
  '';

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://www.villehelin.com/wla.html";
    description = "Yet Another GB-Z80/Z80/6502/65C02/6510/65816/HUC6280/SPC-700 Multi Platform Cross Assembler Package";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ naderhaj ];
    platforms = lib.platforms.all;
  };
})
