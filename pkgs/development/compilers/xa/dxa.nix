{ lib
, stdenv
, fetchurl
, installShellFiles
}:

stdenv.mkDerivation rec {
  pname = "dxa";
  version = "0.1.4";

  src = fetchurl {
    url = "https://www.floodgap.com/retrotech/xa/dists/${pname}-${version}.tar.gz";
    hash = "sha256-C0rgwK51Ij9EZCm9GeiVnWIkEkse0d60ok8G9hm2a5U=";
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
