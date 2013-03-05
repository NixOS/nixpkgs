# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  name = "python32-docs-text-3.2.3";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/3.2.3/python-3.2.3-docs-text.tar.bz2;
    sha256 = "1jdc9rj2b4vsbvg5mq6vcdfa2b72avhhvjw7rn7k3kl521cvxs09";
  };
  installPhase = ''
    mkdir -p $out/share/doc
    cp -R ./ $out/share/doc/${name}
  '';
  meta = {
    maintainers = [ lib.maintainers.chaoflow ];
  };
}
