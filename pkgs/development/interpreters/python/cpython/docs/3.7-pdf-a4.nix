# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  name = "python37-docs-pdf-a4-3.7.2";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/3.7.2/python-3.7.2-docs-pdf-a4.tar.bz2;
    sha256 = "0vdx762m30hjaabn6w88awcj2qpbz0b6z59zn9wmamd35k59lfba";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python37
    cp -R ./ $out/share/doc/python37/pdf-a4
  '';
  meta = {
    maintainers = [ ];
  };
}
