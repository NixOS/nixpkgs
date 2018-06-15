{ stdenv, fetchurl, meson, ninja, gettext, pkgconfig, spidermonkey_52, glib
, gnome3, substituteAll }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extensions-${version}";
  version = "3.28.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-shell-extensions/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0n4h8rdnq3knrvlg6inrl62a73h20dbhfgniwy18572jicrh5ip9";
  };

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-shell-extensions";
      attrPath = "gnome3.gnome-shell-extensions";
    };
  };

  patches = [
    (substituteAll {
      src = ./fix_gmenu.patch;
      gmenu_path = "${gnome3.gnome-menus}/lib/girepository-1.0";
    })
  ];

  doCheck = true;

  nativeBuildInputs = [ meson ninja pkgconfig gettext glib ];
  buildInputs = [ spidermonkey_52 ];

  mesonFlags = [ "-Dextension_set=all" ];

  preFixup = ''
    # The meson build doesn't compile the schemas.
    # Fixup adapted from export-zips.sh in the source.

    extensiondir=$out/share/gnome-shell/extensions
    schemadir=$out/share/gsettings-schemas/${name}/glib-2.0/schemas/

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

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GnomeShell/Extensions;
    description = "Modify and extend GNOME Shell functionality and behavior";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
