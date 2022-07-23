{ lib
, stdenv
, fetchurl
, pkg-config
, glib
, python3
, systemd
, withIntrospection ? stdenv.hostPlatform == stdenv.buildPlatform
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "libmbim";
  version = "1.26.4";

  outputs = [ "out" "dev" "man" ];

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libmbim/${pname}-${version}.tar.xz";
    sha256 = "sha256-9ojOxMRYahdXX14ydEjOYvIADvagfJ5FiYc9SmhWitk=";
  };

  configureFlags = [
    "--with-udev-base-dir=${placeholder "out"}/lib/udev"
    (lib.enableFeature withIntrospection "introspection")
  ];

  nativeBuildInputs = [
    pkg-config
    python3
    gobject-introspection
  ];

  buildInputs = [
    glib
    systemd
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/libmbim/";
    description = "Library for talking to WWAN modems and devices which speak the Mobile Interface Broadband Model (MBIM) protocol";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
