# This file was generated and will be overwritten by ./generate.sh

{
  stdenv,
  fetchurl,
  lib,
}:

stdenv.mkDerivation {
  pname = "python314-docs-pdf-a4";
  version = "3.14";

  src = fetchurl {
    url = "https://docs.python.org/3.14/archives/python-3.14-docs-pdf-a4.tar.bz2";
    sha256 = "0nb69h3wz2vixf80alh9x8fafz3ipq2hdrxccj8vp8vvrcqna75y";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python314
    cp -R ./ $out/share/doc/python314/pdf-a4
  '';
  meta = {
    maintainers = with lib.maintainers; [
      panicgh
    ];
  };
}
