{ lib
, stdenv
, fetchurl
, installShellFiles
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dxa";
  version = "0.1.5";

  src = fetchurl {
    urls = [
      "https://www.floodgap.com/retrotech/xa/dists/dxa-${finalAttrs.version}.tar.gz"
      "https://www.floodgap.com/retrotech/xa/dists/unsupported/dxa-${finalAttrs.version}.tar.gz"
    ];
    hash = "sha256-jkDtd4FlgfmtlaysLtaaL7KseFDkM9Gc1oQZOkWCZ5k=";
  };

  nativeBuildInputs = [ installShellFiles ];

  dontConfigure = true;

  postPatch = ''
    substituteInPlace Makefile \
      --replace "CC = gcc" "CC = ${stdenv.cc.targetPrefix}cc"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -T dxa $out/bin/dxa
    installManPage dxa.1

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.floodgap.com/retrotech/xa/";
    description = "Andre Fachat's open-source 6502 disassembler";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = with lib.platforms; unix;
  };
})
