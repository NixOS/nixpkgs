# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl, lib }:

stdenv.mkDerivation {
  pname = "python27-docs-html";
  version = "2.7.18";

  src = fetchurl {
    url = "http://www.python.org/ftp/python/doc/2.7.18/python-2.7.18-docs-html.tar.bz2";
    sha256 = "03igxwpqc2lvzspnj78zz1prnmfwwj00jbvh1wsxvb0wayd5wi10";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python27
    cp -R ./ $out/share/doc/python27/html
  '';
  meta = {
    maintainers = [ ];
  };
}
