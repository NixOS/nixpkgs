{ lib
, stdenv
, fetchurl
, pkg-config
, dbus
, libgcrypt
, pam
, python3
, glib
, libxslt
, gettext
, gcr
, autoreconfHook
, libcap_ng
, libselinux
, p11-kit
, openssh
, wrapGAppsHook
, docbook-xsl-nons
, docbook_xml_dtd_43
, gnome
}:

stdenv.mkDerivation rec {
  pname = "gnome-keyring";
  version = "42.1";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-keyring/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "x/TQQMx2prf+Z+CO+RBpEcPIDUD8iMv8jiaEpMlG4+Y=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    libxslt
    # Upstream uses ancient autotools to pre-generate the scripts.
    autoreconfHook
    docbook-xsl-nons
    docbook_xml_dtd_43
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    libgcrypt
    pam
    openssh
    libcap_ng
    libselinux
    gcr
    p11-kit
  ];

  checkInputs = [ dbus python3 ];

  configureFlags = [
    "--with-pkcs11-config=${placeholder "out"}/etc/pkcs11/" # installation directories
    "--with-pkcs11-modules=${placeholder "out"}/lib/pkcs11/"
  ];

  # Tends to fail non-deterministically.
  # - https://github.com/NixOS/nixpkgs/issues/55293
  # - https://github.com/NixOS/nixpkgs/issues/51121
  doCheck = false;

  postPatch = ''
    patchShebangs build
  '';

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
    updateScript = gnome.updateScript {
      packageName = "gnome-keyring";
      attrPath = "gnome.gnome-keyring";
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
