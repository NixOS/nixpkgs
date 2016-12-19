{ stdenv, fetchurl, vala_0_23, python, intltool, pkgconfig
, glib, libgee_0_6, gtk3, dee, libdbusmenu-glib
}:

stdenv.mkDerivation rec {
  name = "libunity-${version}";
  version = "6.12.0";

  src = fetchurl {
    url = "https://launchpad.net/libunity/6.0/${version}/+download/${name}.tar.gz";
    sha256 = "1nadapl3390x98q1wv2yarh60hzi7ck0d1s8zz9xsiq3zz6msbjd";
  };

  buildInputs = [ glib libgee_0_6 gtk3 ];
  propagatedBuildInputs = [ dee libdbusmenu-glib ];
  nativeBuildInputs = [ vala_0_23 python intltool pkgconfig ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A library for instrumenting- and integrating with all aspects of the Unity shell";
    homepage = "https://launchpad.net/libunity";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
