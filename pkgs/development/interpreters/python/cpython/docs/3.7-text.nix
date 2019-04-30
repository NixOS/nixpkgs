# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  name = "python37-docs-text-3.7.2";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/3.7.2/python-3.7.2-docs-text.tar.bz2;
    sha256 = "0h50rlr8jclwfxa106b42q2vn2ynp219c4zsy5qz65n5m3b7y1g2";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python37
    cp -R ./ $out/share/doc/python37/text
  '';
  meta = {
    maintainers = [ ];
  };
}
