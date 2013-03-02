# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "python33-docs-pdf-letter-3.3.0";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/3.3.0/python-3.3.0-docs-pdf-letter.tar.bz2;
    sha256 = "0mcj1i47nx81fc9zk1cic4c4p139qjcqlzf4hnnkzvb3jcgy5z6k";
  };
  installPhase = ''
    mkdir -p $out/share/docs
    cp -R ./ $out/share/docs/${name}
  '';
}
