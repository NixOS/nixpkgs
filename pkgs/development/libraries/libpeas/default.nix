{ lib, stdenv, fetchurl, meson, ninja, pkg-config, gettext, gnome
, glib, gtk3, gobject-introspection, python3, ncurses
}:

stdenv.mkDerivation rec {
  pname = "libpeas";
  version = "1.30.0";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "18xrk1c1ixlhkmykcfiafrl2am470ws687xqvjlq40zwkcp5dx8b";
  };

  nativeBuildInputs = [ pkg-config meson ninja gettext gobject-introspection ];
  buildInputs =  [ glib gtk3 ncurses python3 python3.pkgs.pygobject3 ];
  propagatedBuildInputs = [
    # Required by libpeas-1.0.pc
    gobject-introspection
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "A GObject-based plugins engine";
    homepage = "https://wiki.gnome.org/Projects/Libpeas";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
  };
}
