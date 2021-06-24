{ lib, stdenv, fetchurl, fetchpatch, pkg-config, dbus, libgcrypt, pam, python2, glib, libxslt
, gettext, gcr, libcap_ng, libselinux, p11-kit, openssh, wrapGAppsHook
, docbook_xsl, docbook_xml_dtd_43, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gnome-keyring";
  version = "3.36.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-keyring/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "11sgffrrpss5cmv3b717pqlbhgq17l1xd33fsvqgsw8simxbar52";
  };

  patches = [
    # version 3.36.0 is incompatible with libncap_ng >= 0.8.1. remove patch after update.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-keyring/-/commit/ebc7bc9efacc17049e54da8d96a4a29943621113.diff";
      sha256 = "07bx7zmdswqsa3dj37m729g35n1prhylkw7ya8a7h64i10la12cs";
    })
  ];

  outputs = [ "out" "dev" ];

  buildInputs = [
    glib libgcrypt pam openssh libcap_ng libselinux
    gcr p11-kit
  ];

  nativeBuildInputs = [
    pkg-config gettext libxslt docbook_xsl docbook_xml_dtd_43 wrapGAppsHook
  ];

  configureFlags = [
    "--with-pkcs11-config=${placeholder "out"}/etc/pkcs11/" # installation directories
    "--with-pkcs11-modules=${placeholder "out"}/lib/pkcs11/"
  ];

  postPatch = ''
    patchShebangs build
  '';

  # Tends to fail non-deterministically.
  # - https://github.com/NixOS/nixpkgs/issues/55293
  # - https://github.com/NixOS/nixpkgs/issues/51121
  doCheck = false;

  # In 3.20.1, tests do not support Python 3
  checkInputs = [ dbus python2 ];

  checkPhase = ''
    export HOME=$(mktemp -d)
    dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      make check
  '';

  # Use wrapped gnome-keyring-daemon with cap_ipc_lock=ep
  postFixup = ''
    files=($out/etc/xdg/autostart/* $out/share/dbus-1/services/*)

    for file in ''${files[*]}; do
      substituteInPlace $file \
        --replace "$out/bin/gnome-keyring-daemon" "/run/wrappers/bin/gnome-keyring-daemon"
    done
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-keyring";
      attrPath = "gnome3.gnome-keyring";
    };
  };

  meta = with lib; {
    description = "Collection of components in GNOME that store secrets, passwords, keys, certificates and make them available to applications";
    homepage = "https://wiki.gnome.org/Projects/GnomeKeyring";
    license = licenses.gpl2;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
