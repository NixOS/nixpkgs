# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "python312-docs-texinfo";
  version = "3.12.5";

  src = fetchurl {
    url = "http://www.python.org/ftp/python/doc/3.12.5/python-3.12.5-docs-texinfo.tar.bz2";
    sha256 = "14n6qap630gx5fan3rdmfxg3xz4isqjbpbakzfxbbwpynwrba9xc";
  };
  installPhase = ''
    mkdir -p $out/share/info
    cp ./python.info $out/share/info
  '';
  meta = {
    maintainers = [ ];
  };
}
