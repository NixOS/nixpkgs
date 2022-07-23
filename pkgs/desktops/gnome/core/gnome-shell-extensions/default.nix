{ lib
, stdenv
, fetchurl
, meson
, ninja
, gettext
, pkg-config
, glib
, gnome
, gnome-menus
, substituteAll
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extensions";
  version = "43.alpha";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-shell-extensions/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "zoqztQf0NCz6Z3F/zL/VD8LW0sHOVu3SvnTtDyawlu8=";
  };

  patches = [
    (substituteAll {
      src = ./fix_gmenu.patch;
      gmenu_path = "${gnome-menus}/lib/girepository-1.0";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    glib
  ];

  mesonFlags = [
    "-Dextension_set=all"
  ];

  preFixup = ''
    # The meson build doesn't compile the schemas.
    # Fixup adapted from export-zips.sh in the source.

    extensiondir=$out/share/gnome-shell/extensions
    schemadir=${glib.makeSchemaPath "$out" "${pname}-${version}"}

    glib-compile-schemas $schemadir

    for f in $extensiondir/*; do
      name=`basename ''${f%%@*}`
      uuid=$name@gnome-shell-extensions.gcampax.github.com
      schema=$schemadir/org.gnome.shell.extensions.$name.gschema.xml

      if [ -f $schema ]; then
        mkdir $f/schemas
        ln -s $schema $f/schemas;
        glib-compile-schemas $f/schemas
      fi
    done
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Projects/GnomeShell/Extensions";
    description = "Modify and extend GNOME Shell functionality and behavior";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
