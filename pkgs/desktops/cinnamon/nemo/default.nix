{ fetchFromGitHub
, fetchpatch
, glib
, gobject-introspection
, meson
, ninja
, pkgconfig
, stdenv
, wrapGAppsHook
, libxml2
, gtk3
, libnotify
, cinnamon-desktop
, xapps
, libexif
, exempi
, intltool
, shared-mime-info
}:

stdenv.mkDerivation rec {
  pname = "nemo";
  version = "4.4.1";

  # TODO: add plugins support (see https://github.com/NixOS/nixpkgs/issues/78327)

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "0sskq0rssxvna937md446x1489hkhxys1zq03hvl8asjqa259w2q";
  };

  patches = [
    (fetchpatch { # details see https://github.com/linuxmint/nemo/pull/2303
      url = "https://github.com/linuxmint/nemo/pull/2303/commits/9c1ec7812abe712419317df07d6b64623e8f639d.patch";
      sha256 = "09dz7lq3i47rbvycawrxwgjmd9g1mhb76ibx2vq85wck6r08arml";
    })
  ];

  outputs = [ "out" "dev" ];

  buildInputs = [
    glib
    gtk3
    libnotify
    cinnamon-desktop
    libxml2
    xapps
    libexif
    exempi
    gobject-introspection
  ];

  nativeBuildInputs = [
    meson
    pkgconfig
    ninja
    wrapGAppsHook
    intltool
    shared-mime-info
  ];

  mesonFlags = [
    # TODO: https://github.com/NixOS/nixpkgs/issues/36468
    "-Dc_args=-I${glib.dev}/include/gio-unix-2.0"
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/linuxmint/nemo";
    description = "File browser for Cinnamon";
    license = [ licenses.gpl2 licenses.lgpl2 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.mkg20001 ];
  };
}
