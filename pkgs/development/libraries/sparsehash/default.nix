{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "sparsehash-2.0.2";

  src = fetchurl {
    url = http://sparsehash.googlecode.com/files/sparsehash-2.0.2.tar.gz;
    sha256 = "0z5qa1sbp6xx5qpdvrdjh185k5kj53sgb6h2qabw01sn2nkkkmif";
  };

  meta = with stdenv.lib; {
    homepage = "http://code.google.com/p/sparsehash/";
    description = "An extremely memory-efficient hash_map implementation";
    platforms = platforms.all;
    license = licenses.bsd3;
  };
}
