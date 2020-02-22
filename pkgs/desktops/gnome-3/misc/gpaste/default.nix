{ stdenv
, fetchFromGitHub
, fetchpatch
, appstream-glib
, clutter
, gjs
, glib
, gnome3
, gobject-introspection
, gtk3
, meson
, mutter
, ninja
, pango
, pkgconfig
, vala
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  version = "3.34.1";
  pname = "gpaste";

  src = fetchFromGitHub {
    owner = "Keruspe";
    repo = "GPaste";
    rev = "v${version}";
    sha256 = "1jcj0kgxhad8rblyqhwa2yhkf0010k80w9bm2rajanad2c3bqaxa";
  };

  patches = [
    # Meson fixes
    # https://github.com/Keruspe/GPaste/pull/283
    # install systemd units
    (fetchpatch {
      url = "https://github.com/Keruspe/GPaste/commit/a474d8c1f2bd600476ba52dc19f517787845533b.patch";
      sha256 = "19m1ar61l2n0vb5a5qfhdny8giivqlyq04l3j9i8llv16vx80rg2";
    })
    # apply symbol versioning
    (fetchpatch {
      url = "https://github.com/Keruspe/GPaste/commit/08047752e8dba9363673ddefd422c43075f08006.patch";
      sha256 = "0jvcs1a17sijvb2wqyn3y8shdxrhv4kwzxs39kmh9y8nyx2dzhpf";
    })

    ./fix-paths.patch
  ];

  # TODO: switch to substituteAll with placeholder
  # https://github.com/NixOS/nix/issues/1846
  postPatch = ''
    substituteInPlace src/gnome-shell/extension.js \
      --subst-var-by typelibPath "${placeholder "out"}/lib/girepository-1.0"
    substituteInPlace src/gnome-shell/prefs.js \
      --subst-var-by typelibPath "${placeholder "out"}/lib/girepository-1.0"
    substituteInPlace src/libgpaste/settings/gpaste-settings.c \
      --subst-var-by gschemasCompiled ${glib.makeSchemaPath (placeholder "out") "${pname}-${version}"}
  '';

  nativeBuildInputs = [
    appstream-glib
    gobject-introspection
    meson
    ninja
    pkgconfig
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    clutter # required by mutter-clutter
    gjs
    glib
    gtk3
    mutter
    pango
  ];

  mesonFlags = [
    "-Dcontrol-center-keybindings-dir=${placeholder "out"}/share/gnome-control-center/keybindings"
    "-Ddbus-services-dir=${placeholder "out"}/share/dbus-1/services"
    "-Dsystemd-user-unit-dir=${placeholder "out"}/etc/systemd/user"
  ];

  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/Keruspe/GPaste";
    description = "Clipboard management system with GNOME 3 integration";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
