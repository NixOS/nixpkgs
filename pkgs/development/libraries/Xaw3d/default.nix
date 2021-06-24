{ lib, stdenv, fetchurl
, imake, gccmakedep, bison, flex, pkg-config
, xlibsWrapper, libXmu, libXpm, libXp }:

stdenv.mkDerivation {
  name = "Xaw3d-1.6.3";
  src = fetchurl {
    url = "https://www.x.org/releases/individual/lib/libXaw3d-1.6.3.tar.bz2";
    sha256 = "0i653s8g25cc0mimkwid9366bqkbyhdyjhckx7bw77j20hzrkfid";
  };
  dontUseImakeConfigure = true;
  nativeBuildInputs = [ pkg-config bison flex imake gccmakedep ];
  buildInputs = [ libXpm libXp ];
  propagatedBuildInputs = [ xlibsWrapper libXmu ];

  meta = with lib; {
    description = "3D widget set based on the Athena Widget set";
    platforms = lib.platforms.unix;
    license = licenses.mit;
  };
}
