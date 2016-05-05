{ stdenv, fetchurl, cracklib, python }:

stdenv.mkDerivation rec {
  name = "libpwquality-${version}";
  version = "1.3.0";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/l/i/libpwquality/${name}.tar.bz2";
    sha256 = "0aidriag6h0syfm33nzdfdsqgrnsgihwjv3a5lgkqch3w68fmlkl";
  };

  buildInputs = [ cracklib python ];
}
