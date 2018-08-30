{ stdenv, fetchurl, pkgconfig, glib, gtk3, libgee, intltool, gnome3
, libintl }:

let
  pname = "libgnome-games-support";
  version = "1.4.2";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "02hirpk885jndwarbl3cl5fk7w2z5ziv677csyv1wi2n6rmpn088";
  };

  nativeBuildInputs = [ pkgconfig intltool ];
  buildInputs = [ libintl ];
  propagatedBuildInputs = [
    # Required by libgnome-games-support-1.pc
    glib gtk3 libgee
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "Small library intended for internal use by GNOME Games, but it may be used by others";
    homepage = https://wiki.gnome.org/Apps/Games;
    license = licenses.lgpl3;
    maintainers = gnome3.maintainers;
    platforms = platforms.unix;
  };
}
