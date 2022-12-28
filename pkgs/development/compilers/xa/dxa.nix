{ lib
, stdenv
, fetchurl
, installShellFiles
}:

stdenv.mkDerivation rec {
  pname = "dxa";
  version = "0.1.5";

  src = fetchurl {
    urls = [
      "https://www.floodgap.com/retrotech/xa/dists/${pname}-${version}.tar.gz"
      "https://www.floodgap.com/retrotech/xa/dists/unsupported/${pname}-${version}.tar.gz"
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
    install -d $out/bin/
    install dxa $out/bin/
    installManPage dxa.1
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.floodgap.com/retrotech/xa/";
    description = "Andre Fachat's open-source 6502 disassembler";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };
}
