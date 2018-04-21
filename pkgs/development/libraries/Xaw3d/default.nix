{stdenv, fetchurl, xlibsWrapper, imake, gccmakedep, libXmu, libXpm, libXp, bison, flex, pkgconfig}:

stdenv.mkDerivation {
  name = "Xaw3d-1.6.2";
  src = fetchurl {
    url = https://www.x.org/releases/individual/lib/libXaw3d-1.6.2.tar.bz2;
    sha256 = "0awplv1nf53ywv01yxphga3v6dcniwqnxgnb0cn4khb121l12kxp";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [imake gccmakedep libXpm libXp bison flex];
  propagatedBuildInputs = [xlibsWrapper libXmu];

  meta = {
    description = "3D widget set based on the Athena Widget set";
    platforms = stdenv.lib.platforms.unix;
  };
}
