{ lib, stdenv, fetchurl, fetchpatch, meson, ninja, gettext, pkg-config, spidermonkey_68, glib
, gnome, gnome-menus, substituteAll }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extensions";
  version = "40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-shell-extensions/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "15hak4prx2nx1svfii39clxy1lll8crdf7p91if85jcsh6r8ab8p";
  };

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  patches = [
    (substituteAll {
      src = ./fix_gmenu.patch;
      gmenu_path = "${gnome-menus}/lib/girepository-1.0";
    })

    # Do not show welcome dialog in gnome-classic.
    # Needed for gnome-shell 40.1.
    # https://gitlab.gnome.org/GNOME/gnome-shell-extensions/merge_requests/169
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-shell-extensions/commit/3e8bbb07ea7109c44d5ac7998f473779e742d041.patch";
      sha256 = "jSmPwSBgRBfPPP9mGVjw1mSWumIXQqtA6tSqHr3U+3w=";
    })
  ];

  doCheck = true;
  # 60 is required for tests
  # https://gitlab.gnome.org/GNOME/gnome-shell-extensions/blob/3.34.0/meson.build#L23
  checkInputs = [ spidermonkey_68 ];

  nativeBuildInputs = [ meson ninja pkg-config gettext glib ];

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

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Projects/GnomeShell/Extensions";
    description = "Modify and extend GNOME Shell functionality and behavior";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
