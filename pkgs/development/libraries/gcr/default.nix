{ lib, stdenv
, fetchurl
, fetchpatch
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
, systemd
, gobject-introspection
, wrapGAppsHook
, libxslt
, vala
, gnome
, python3
, shared-mime-info
}:

stdenv.mkDerivation rec {
  pname = "gcr";
  version = "3.41.0";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "CQn8SeqK1IMtJ1ZP8v0dxmZpbioHxzlBxIgp5gVy2gE=";
  };

  patches = [
    # Pull upstream fix for meson-0.60:
    #  https://gitlab.gnome.org/GNOME/gcr/-/merge_requests/81
    (fetchpatch {
      name = "meson-0.60.patch";
      url = "https://gitlab.gnome.org/GNOME/gcr/-/commit/b3ca1d02bb0148ca787ac4aead164d7c8ce2c4d8.patch";
      sha256 = "15gwxkcm5q5p87p5lrqwgykpzx5gmk179xd3481yak93yhbvy165";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    python3
    ninja
    gettext
    gobject-introspection
    libxslt
    wrapGAppsHook
    vala
    shared-mime-info
  ];

  buildInputs = [
    gnupg
    libgcrypt
    libtasn1
    pango
    libsecret
    openssh
    systemd
  ];

  propagatedBuildInputs = [
    glib
    gtk3
    p11-kit
  ];

  checkInputs = [
    python3
  ];

  mesonFlags = [
    "-Dgtk_doc=false"
    # We are still using ssh-agent from gnome-keyring.
    # https://github.com/NixOS/nixpkgs/issues/140824
    "-Dssh_agent=false"
  ];

  doCheck = false; # fails 21 out of 603 tests, needs dbus daemon

  PKG_CONFIG_SYSTEMD_SYSTEMDUSERUNITDIR = "${placeholder "out"}/lib/systemd/user";

  postPatch = ''
    patchShebangs build/ gcr/fixtures/

    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
    description = "GNOME crypto services (daemon and tools)";
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
