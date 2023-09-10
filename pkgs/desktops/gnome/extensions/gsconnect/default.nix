{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, substituteAll
, openssl
, gsound
, meson
, ninja
, pkg-config
, gobject-introspection
, wrapGAppsHook
, glib
, glib-networking
, gtk3
, openssh
, gnome
, evolution-data-server-gtk4
, gjs
, nixosTests
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-gsconnect";
  version = "55";

  outputs = [ "out" "installedTests" ];

  src = fetchFromGitHub {
    owner = "GSConnect";
    repo = "gnome-shell-extension-gsconnect";
    rev = "v${version}";
    hash = "sha256-n6NbNgl+2FOhly/BeR7I6BvPOYe7leAdeAegaqhcGJU=";
  };

  patches = [
    # Make typelibs available in the extension
    (substituteAll {
      src = ./fix-paths.patch;
      gapplication = "${glib.bin}/bin/gapplication";
    })

    # Allow installing installed tests to a separate output
    ./installed-tests-path.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection # for locating typelibs
    wrapGAppsHook # for wrapping daemons
    desktop-file-utils # update-desktop-database
  ];

  buildInputs = [
    glib # libgobject
    glib-networking
    gtk3
    gsound
    gjs # for running daemon
    evolution-data-server-gtk4 # for libebook-contacts typelib
  ];

  mesonFlags = [
    "-Dgnome_shell_libdir=${gnome.gnome-shell}/lib"
    "-Dchrome_nmhdir=${placeholder "out"}/etc/opt/chrome/native-messaging-hosts"
    "-Dchromium_nmhdir=${placeholder "out"}/etc/chromium/native-messaging-hosts"
    "-Dopenssl_path=${openssl}/bin/openssl"
    "-Dsshadd_path=${openssh}/bin/ssh-add"
    "-Dsshkeygen_path=${openssh}/bin/ssh-keygen"
    "-Dsession_bus_services_dir=${placeholder "out"}/share/dbus-1/services"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
  ];

  postPatch = ''
    patchShebangs installed-tests/prepare-tests.sh

    # TODO: do not include every typelib everywhere
    # for example, we definitely do not need nautilus
    for file in src/extension.js src/prefs.js; do
      substituteInPlace "$file" \
        --subst-var-by typelibPath "$GI_TYPELIB_PATH"
    done

    # slightly janky fix for gsettings_schemadir being removed
    substituteInPlace data/config.js.in \
      --subst-var-by GSETTINGS_SCHEMA_DIR ${glib.makeSchemaPath (placeholder "out") "${pname}-${version}"}
  '';

  postFixup = ''
    # Let’s wrap the daemons
    for file in $out/share/gnome-shell/extensions/gsconnect@andyholmes.github.io/service/{daemon,nativeMessagingHost}.js; do
      echo "Wrapping program $file"
      wrapGApp "$file"
    done

    # Wrap jasmine runner for tests
    for file in $installedTests/libexec/installed-tests/gsconnect/minijasmine; do
      echo "Wrapping program $file"
      wrapGApp "$file"
    done
  '';

  passthru = {
    extensionUuid = "gsconnect@andyholmes.github.io";
    extensionPortalSlug = "gsconnect";
  };

  passthru = {
    tests = {
      installedTests = nixosTests.installed-tests.gsconnect;
    };
  };

  meta = with lib; {
    description = "KDE Connect implementation for Gnome Shell";
    homepage = "https://github.com/GSConnect/gnome-shell-extension-gsconnect/wiki";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
