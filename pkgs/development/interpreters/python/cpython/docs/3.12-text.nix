# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "python312-docs-text";
  version = "3.12.5";

  src = fetchurl {
    url = "http://www.python.org/ftp/python/doc/3.12.5/python-3.12.5-docs-text.tar.bz2";
    sha256 = "16j9kr566kyw60r9bc54i01naikjclbyxjsliv33sykniwlmm0rv";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python312
    cp -R ./ $out/share/doc/python312/text
  '';
  meta = {
    maintainers = [ ];
  };
}
