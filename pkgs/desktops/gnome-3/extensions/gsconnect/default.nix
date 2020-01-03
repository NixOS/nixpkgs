{ stdenv, fetchFromGitHub, substituteAll, python3, openssl, folks, gsound
, meson, ninja, libxml2, pkgconfig, gobject-introspection, wrapGAppsHook
, glib, gtk3, at-spi2-core, upower, openssh, gnome3, gjs }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-gsconnect";
  version = "30";

  src = fetchFromGitHub {
    owner = "andyholmes";
    repo = "gnome-shell-extension-gsconnect";
    rev = "v${version}";
    sha256 = "17j96y72mj7vg2csn5c9rji7jy04x5qzl8knf5gky6wppxj9zjb4";
  };

  patches = [
    # Make typelibs available in the extension
    (substituteAll {
      src = ./fix-paths.patch;
      gapplication = "${glib.bin}/bin/gapplication";
    })
  ];

  nativeBuildInputs = [
    meson ninja pkgconfig
    gobject-introspection # for locating typelibs
    wrapGAppsHook # for wrapping daemons
    libxml2 # xmllint
  ];

  buildInputs = [
    (python3.withPackages (pkgs: [ python3.pkgs.pygobject3 ])) # for folks.py
    glib # libgobject
    gtk3
    at-spi2-core # atspi
    folks # libfolks
    gnome3.nautilus # TODO: this contaminates the package with nautilus and gnome-autoar typelibs but it is only needed for the extension
    gnome3.nautilus-python
    gsound
    upower
    gnome3.caribou
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
    "-Dpost_install=true"
  ];

  postPatch = ''
    patchShebangs meson/nmh.sh
    patchShebangs meson/post-install.sh

    # TODO: do not include every typelib everywhere
    # for example, we definitely do not need nautilus
    for file in src/extension.js src/prefs.js; do
      substituteInPlace "$file" \
        --subst-var-by typelibPath "$GI_TYPELIB_PATH"
    done
  '';

  preFixup = ''
    # TODO: figure out why folks GIR does not contain shared-library attribute
    # https://github.com/NixOS/nixpkgs/issues/47226
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ folks ]}")
  '';

  postFixup = ''
    # Let’s wrap the daemons
    for file in $out/share/gnome-shell/extensions/gsconnect@andyholmes.github.io/service/{{daemon,nativeMessagingHost}.js,components/folks.py}; do
      echo "Wrapping program $file"
      wrapGApp "$file"
    done
  '';

  meta = with stdenv.lib; {
    description = "KDE Connect implementation for Gnome Shell";
    homepage = https://github.com/andyholmes/gnome-shell-extension-gsconnect/wiki;
    license = licenses.gpl2;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
