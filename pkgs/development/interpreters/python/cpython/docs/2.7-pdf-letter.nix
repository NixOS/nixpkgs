# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  name = "python27-docs-pdf-letter-2.7.16";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/2.7.16/python-2.7.16-docs-pdf-letter.tar.bz2;
    sha256 = "019i8n48m71mn31v8d85kkwyqfgcgqnqh506y4a7fcgf656bajs0";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python27
    cp -R ./ $out/share/doc/python27/pdf-letter
  '';
  meta = {
    maintainers = [ ];
  };
}
