{ stdenv, fetchurl, perl }:

let
  version = "2.1.0";
in
stdenv.mkDerivation {
  pname = "uthash";
  inherit version;

  src = fetchurl {
    url = "https://github.com/troydhanson/uthash/archive/v${version}.tar.gz";
    sha256 = "17k6k97n20jpi9zj3lzvqfw8pv670r6rdqrjf8vrbx6hcj7csb0m";
  };

  dontBuild = false;

  doCheck = true;
  checkInputs = [ perl ];
  checkTarget = "-C tests/";

  installPhase = ''
    mkdir -p "$out/include"
    cp ./src/* "$out/include/"
  '';

  meta = with stdenv.lib; {
    description = "A hash table for C structures";
    homepage    = "http://troydhanson.github.io/uthash";
    license     = licenses.bsd2; # it's one-clause, actually, as it's source-only
    platforms   = platforms.all;
  };
}
