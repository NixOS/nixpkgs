{ stdenv, fetchurl, glib, dbus, libgcrypt, pkgconfig, intltool }:

stdenv.mkDerivation rec {
  pname = "libgnome-keyring";
  version = "2.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "030gka96kzqg1r19b4xrmac89hf1xj1kr5p461yvbzfxh46qqf2n";
  };

  outputs = [ "out" "dev" ];

  propagatedBuildInputs = [ glib dbus libgcrypt ];
  nativeBuildInputs = [ pkgconfig intltool ];

  meta = {
    inherit (glib.meta) platforms maintainers;
    license = with stdenv.lib.licenses; [ gpl2 lgpl2 ];
  };
}
