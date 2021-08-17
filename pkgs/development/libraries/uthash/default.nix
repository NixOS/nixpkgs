{ lib, stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  pname = "uthash";
  version = "2.3.0";

  src = fetchurl {
    url = "https://github.com/troydhanson/uthash/archive/v${version}.tar.gz";
    sha256 = "sha256-4QOCq3VRi62DGeuSKtBPkHyyDMy0UaOqmAydAF5mGsw=";
  };

  dontBuild = false;

  doCheck = true;
  checkInputs = [ perl ];
  checkTarget = "-C tests/";

  installPhase = ''
    mkdir -p "$out/include"
    cp ./src/* "$out/include/"
  '';

  meta = with lib; {
    description = "A hash table for C structures";
    homepage    = "http://troydhanson.github.io/uthash";
    license     = licenses.bsd2; # it's one-clause, actually, as it's source-only
    platforms   = platforms.all;
  };
}
