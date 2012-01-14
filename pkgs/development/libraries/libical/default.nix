{stdenv, fetchurl, perl}:

stdenv.mkDerivation rec {
  name = "libical-0.48";
  src = fetchurl {
    url = "mirror://sourceforge/freeassociation/${name}.tar.gz";
    sha256 = "1w6znkh0xxhbcm717mbzfva9ycrqs2lajhng391i7pghaw3qprra";
  };
  buildNativeInputs = [ perl ];
}
