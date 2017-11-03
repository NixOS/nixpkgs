{ stdenv, fetchurl, perl }:

let
  version = "2.0.2";
in
stdenv.mkDerivation rec {
  name = "uthash-${version}";

  src = fetchurl {
    url = "https://github.com/troydhanson/uthash/archive/v${version}.tar.gz";
    sha256 = "1la82gdlyl7m8ahdjirigwfh7zjgkc24cvydrqcri0vsvm8iv8rl";
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

