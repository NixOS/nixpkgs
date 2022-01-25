# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  pname = "python27-docs-html";
  version = "2.7.16";

  src = fetchurl {
    url = "http://docs.python.org/ftp/python/doc/${version}/python-${version}-docs-html.tar.bz2";
    sha256 = "1razs1grzhai65ihaiyph8kz6ncjkgp1gsn3c8v7kanf13lqim02";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python27
    cp -R ./ $out/share/doc/python27/html
  '';
  meta = {
    maintainers = [ ];
  };
}
