# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  pname = "python37-docs-pdf-a4";
  version = "3.10.1";

  src = fetchurl {
    url = "http://docs.python.org/ftp/python/doc/${version}/python-${version}-docs-pdf-a4.tar.bz2";
    sha256 = "sha256-GccVzywQeJunE5Y4A9NPo+P3VEUUSyQ2gVAaNTLVBo8=";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python37
    cp -R ./ $out/share/doc/python37/pdf-a4
  '';
  meta = {
    maintainers = [ ];
  };
}
