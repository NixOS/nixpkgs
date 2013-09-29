{stdenv, fetchurl, perl, cmake}:

stdenv.mkDerivation rec {
  pName = "libical";
  name = "${pName}-1.0";
  src = fetchurl {
    url = "mirror://sourceforge/freeassociation/${pName}/${name}/${name}.tar.gz";
    sha256 = "1dy0drz9hy0sn2q3s2lp00jb9bis5gsm7n3m4zga49s9ir2b6fbw";
  };
  nativeBuildInputs = [ perl cmake ];

  patches = [ ./respect-env-tzdir.patch ];
}
