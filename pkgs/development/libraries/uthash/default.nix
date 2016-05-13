{ stdenv, fetchurl, perl }:

let
  version = "1.9.9";
in
stdenv.mkDerivation rec {
  name = "uthash-${version}";

  src = fetchurl {
    url = "https://github.com/troydhanson/uthash/archive/v${version}.tar.gz";
    sha256 = "035z3cs5ignywgh4wqxx358a2nhn3lj0x1ifij6vj0yyyhah3wgj";
  };

  dontBuild = false;

  buildInputs = stdenv.lib.optional doCheck perl;

  doCheck = true;
  checkTarget = "-C tests/";

  installPhase = ''
    mkdir -p "$out/include"
    cp ./src/* "$out/include/"
  '';

  meta = with stdenv.lib; {
    description = "A hash table for C structures";
    homepage    = http://troydhanson.github.io/uthash;
    license     = licenses.bsd2; # it's one-clause, actually, as it's source-only
    platforms   = platforms.all;
  };
}

