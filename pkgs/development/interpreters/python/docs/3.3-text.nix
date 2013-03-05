# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  name = "python33-docs-text-3.3.0";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/3.3.0/python-3.3.0-docs-text.tar.bz2;
    sha256 = "10vk2fixg1aglqmsf89kn98rlirrbhnrk1285vzfbynf2iavxw0n";
  };
  installPhase = ''
    mkdir -p $out/share/doc
    cp -R ./ $out/share/doc/${name}
  '';
  meta = {
    maintainers = [ lib.maintainers.chaoflow ];
  };
}
