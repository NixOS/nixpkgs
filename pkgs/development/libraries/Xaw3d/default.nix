{ lib
, stdenv
, fetchurl
, imake
, gccmakedep
, bison
, flex
, pkg-config
, libXext
, libXmu
, libXpm
, libXp
, libXt
, xorgproto
}:

stdenv.mkDerivation rec {
  pname = "Xaw3d";
  version = "1.6.3";

  src = fetchurl {
    url = "https://www.x.org/releases/individual/lib/libXaw3d-${version}.tar.bz2";
    sha256 = "0i653s8g25cc0mimkwid9366bqkbyhdyjhckx7bw77j20hzrkfid";
  };
  dontUseImakeConfigure = true;
  nativeBuildInputs = [ pkg-config bison flex imake gccmakedep ];
  buildInputs = [ libXext libXpm libXp ];
  propagatedBuildInputs = [ libXmu libXt xorgproto ];

  meta = with lib; {
    description = "3D widget set based on the Athena Widget set";
    platforms = lib.platforms.unix;
    license = licenses.mit;
  };
}
