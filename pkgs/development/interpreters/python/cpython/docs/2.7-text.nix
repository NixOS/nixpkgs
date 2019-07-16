# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  name = "python27-docs-text-2.7.16";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/2.7.16/python-2.7.16-docs-text.tar.bz2;
    sha256 = "1da7swlykvc013684nywycinfz3v8dqkcmv0zj8p7l5lyi5mq03r";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python27
    cp -R ./ $out/share/doc/python27/text
  '';
  meta = {
    maintainers = [ ];
  };
}
