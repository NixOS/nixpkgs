{ stdenv
, lib
, fetchurl
, autoreconfHook
, pkg-config
, intltool
, gtk-doc
, glib
, avahi
, gnutls
, libuuid
, libsoup
, gtk3
, gnome
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libepc";
  version = "0.4.6";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/libepc/${lib.versions.majorMinor finalAttrs.version}/libepc-${finalAttrs.version}.tar.xz";
    sha256 = "1s3svb2slqjsrqfv50c2ymnqcijcxb5gnx6bfibwh9l5ga290n91";
  };

  patches = [
    # Remove dependency that is only needed by uninstalled examples.
    ./no-avahi-ui.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    gnome.gnome-common
    pkg-config
    intltool
    gtk-doc
  ];

  buildInputs = [
    glib
    libuuid
    gtk3
  ];

  propagatedBuildInputs = [
    avahi
    gnutls
    libsoup
  ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "libepc";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Easy Publish and Consume Library";
    homepage = "https://wiki.gnome.org/Projects/libepc";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
})
