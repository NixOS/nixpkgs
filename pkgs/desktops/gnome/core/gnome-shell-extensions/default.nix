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
  version = "44.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-shell-extensions/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "jDRecvMaHjf1UGPgsVmXMBsBGU7WmHcv2HrrUMuxAas=";
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
    # Since we do not install the schemas to central location,
    # let’s link them to where extensions installed
    # through the extension portal would look for them.
    # Adapted from export-zips.sh in the source.

    extensiondir=$out/share/gnome-shell/extensions
    schemadir=${glib.makeSchemaPath "$out" "$name"}

    for f in $extensiondir/*; do
      name=$(basename "''${f%%@*}")
      schema=$schemadir/org.gnome.shell.extensions.$name.gschema.xml
      schemas_compiled=$schemadir/gschemas.compiled

      if [[ -f $schema ]]; then
        mkdir "$f/schemas"
        ln -s "$schema" "$f/schemas"
        ln -s "$schemas_compiled" "$f/schemas"
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
