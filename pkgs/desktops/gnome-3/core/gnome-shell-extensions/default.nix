{ stdenv, fetchurl, meson, ninja, gettext, pkgconfig, spidermonkey_60, glib
, gnome3, gnome-menus, substituteAll }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extensions";
  version = "3.34.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-shell-extensions/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1f5l35l3kdkzrv49xmg1sh11vwmgjbg7hx3gb91i39bfl1snxqd1";
  };

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  patches = [
    (substituteAll {
      src = ./fix_gmenu.patch;
      gmenu_path = "${gnome-menus}/lib/girepository-1.0";
    })
  ];

  doCheck = true;
  # 60 is required for tests
  # https://gitlab.gnome.org/GNOME/gnome-shell-extensions/blob/3.34.0/meson.build#L23
  checkInputs = [ spidermonkey_60 ];

  nativeBuildInputs = [ meson ninja pkgconfig gettext glib ];

  mesonFlags = [ "-Dextension_set=all" ];

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

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GnomeShell/Extensions;
    description = "Modify and extend GNOME Shell functionality and behavior";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
