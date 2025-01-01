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
, gtk3
, pango
, libsecret
, openssh
, systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd, systemd
, gobject-introspection
, wrapGAppsHook3
, gi-docgen
, vala
, gnome
, python3
, shared-mime-info
}:

stdenv.mkDerivation rec {
  pname = "gcr";
  version = "3.41.2";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "utEPPFU6DhhUZJq1nFskNNoiyhpUrmE48fU5YVZ+Grc=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    meson
    python3
    ninja
    gettext
    gobject-introspection
    gi-docgen
    wrapGAppsHook3
    vala
    shared-mime-info
    openssh
  ];

  buildInputs = [
    libgcrypt
    libtasn1
    pango
    libsecret
    openssh
  ] ++ lib.optionals (systemdSupport) [
    systemd
  ];

  propagatedBuildInputs = [
    glib
    gtk3
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
  ] ++ lib.optionals (!systemdSupport) [
    "-Dsystemd=disabled"
  ];

  doCheck = false; # fails 21 out of 603 tests, needs dbus daemon

  PKG_CONFIG_SYSTEMD_SYSTEMDUSERUNITDIR = "${placeholder "out"}/lib/systemd/user";

  postPatch = ''
    patchShebangs gcr/fixtures/

    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
    substituteInPlace meson_post_install.py --replace ".so" "${stdenv.hostPlatform.extensions.sharedLibrary}"
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      freeze = true;
    };
  };

  meta = with lib; {
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
    description = "GNOME crypto services (daemon and tools)";
    mainProgram = "gcr-viewer";
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
