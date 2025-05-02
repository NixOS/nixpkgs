{ stdenv
, lib
, fetchurl
, pkg-config
, meson
, ninja
, gettext
, gnupg
, p11-kit
, glib
, libgcrypt
, libtasn1
, gtk4
, pango
, libsecret
, openssh
, systemd
, gobject-introspection
, wrapGAppsHook4
, vala
, gi-docgen
, gnome
, python3
, shared-mime-info
}:

stdenv.mkDerivation rec {
  pname = "gcr";
  version = "4.3.0";

  outputs = [ "out" "bin" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-w+6HKOQ2SwOX9DX6IPkvkBqxOdKyZPTgWdZ7PA9DzTY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gettext
    gobject-introspection
    gi-docgen
    wrapGAppsHook4
    vala
    gi-docgen
    shared-mime-info
  ];

  buildInputs = [
    libgcrypt
    libtasn1
    pango
    libsecret
    openssh
    systemd
    gtk4
  ];

  propagatedBuildInputs = [
    glib
    p11-kit
  ];

  nativeCheckInputs = [
    python3
  ];

  mesonFlags = [
    # We are still using ssh-agent from gnome-keyring.
    # https://github.com/NixOS/nixpkgs/issues/140824
    "-Dssh_agent=false"
    "-Dgpg_path=${lib.getBin gnupg}/bin/gpg"
  ];

  doCheck = false; # fails 21 out of 603 tests, needs dbus daemon

  PKG_CONFIG_SYSTEMD_SYSTEMDUSERUNITDIR = "${placeholder "out"}/lib/systemd/user";

  postPatch = ''
    patchShebangs gcr/fixtures/
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "gcr_4";
      packageName = pname;
    };
  };

  meta = with lib; {
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
    description = "GNOME crypto services (daemon and tools)";
    mainProgram = "gcr-viewer-gtk4";
    homepage = "https://gitlab.gnome.org/GNOME/gcr";
    license = licenses.lgpl2Plus;

    longDescription = ''
      GCR is a library for displaying certificates, and crypto UI, accessing
      key stores. It also provides the viewer for crypto files on the GNOME
      desktop.

      GCK is a library for accessing PKCS#11 modules like smart cards, in a
      (G)object oriented way.
    '';
  };
}
