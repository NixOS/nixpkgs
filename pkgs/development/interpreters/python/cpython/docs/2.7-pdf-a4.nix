# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  name = "python27-docs-pdf-a4-2.7.16";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/2.7.16/python-2.7.16-docs-pdf-a4.tar.bz2;
    sha256 = "14ml1ynrlbhg43737bdsb8k5y39wsffqj4iwhylhb8n8l5dplfdq";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python27
    cp -R ./ $out/share/doc/python27/pdf-a4
  '';
  meta = {
    maintainers = [ ];
  };
}
