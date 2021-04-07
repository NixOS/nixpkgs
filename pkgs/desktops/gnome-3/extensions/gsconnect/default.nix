{ lib, stdenv
, fetchFromGitHub
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
, gnome3
, gjs
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-gsconnect";
  version = "44";

  outputs = [ "out" "installedTests" ];

  src = fetchFromGitHub {
    owner = "andyholmes";
    repo = "gnome-shell-extension-gsconnect";
    rev = "v${version}";
    sha256 = "C+8mhK4UOs2iZplDyY45bCX0mMGgwVV/ZfaPpYUlWxA=";
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
  ];

  buildInputs = [
    glib # libgobject
    glib-networking
    gtk3
    gsound
    gjs # for running daemon
    gnome3.evolution-data-server # for libebook-contacts typelib
  ];

  mesonFlags = [
    "-Dgnome_shell_libdir=${gnome3.gnome-shell}/lib"
    "-Dgsettings_schemadir=${glib.makeSchemaPath (placeholder "out") "${pname}-${version}"}"
    "-Dchrome_nmhdir=${placeholder "out"}/etc/opt/chrome/native-messaging-hosts"
    "-Dchromium_nmhdir=${placeholder "out"}/etc/chromium/native-messaging-hosts"
    "-Dopenssl_path=${openssl}/bin/openssl"
    "-Dsshadd_path=${openssh}/bin/ssh-add"
    "-Dsshkeygen_path=${openssh}/bin/ssh-keygen"
    "-Dsession_bus_services_dir=${placeholder "out"}/share/dbus-1/services"
    "-Dpost_install=true"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
  ];

  postPatch = ''
    patchShebangs meson/nmh.sh
    patchShebangs meson/post-install.sh
    patchShebangs installed-tests/prepare-tests.sh

    # TODO: do not include every typelib everywhere
    # for example, we definitely do not need nautilus
    for file in src/extension.js src/prefs.js; do
      substituteInPlace "$file" \
        --subst-var-by typelibPath "$GI_TYPELIB_PATH"
    done
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

  uuid = "gsconnect@andyholmes.github.io";

  passthru = {
    tests = {
      installedTests = nixosTests.installed-tests.gsconnect;
    };
  };

  meta = with lib; {
    description = "KDE Connect implementation for Gnome Shell";
    homepage = "https://github.com/andyholmes/gnome-shell-extension-gsconnect/wiki";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
