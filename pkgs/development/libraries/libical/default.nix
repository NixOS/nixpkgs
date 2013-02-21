{stdenv, fetchsvn, perl, cmake}:

stdenv.mkDerivation rec {
  name = "libical-0.48-p20120623";
  src = fetchsvn {
    url = "https://freeassociation.svn.sourceforge.net/svnroot/freeassociation/trunk/libical";
    rev = "1130";
    sha256 = "56caf19abdf44807fda75a67ef0886319551e53c4e4ece4da4fc862e34c64e1a";
  };
  nativeBuildInputs = [ perl cmake ];

  patches = [ ./respect-env-tzdir.patch ];
}
