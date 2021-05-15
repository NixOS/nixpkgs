{ lib, stdenv, fetchurl, pkg-config, gettext, glib, itstool, libxml2, mate, dconf, gtk3, vte, pcre2, wrapGAppsHook, mateUpdateScript }:

stdenv.mkDerivation rec {
  pname = "mate-terminal";
  version = "1.24.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0qmyhxmarwkxad8k1m9q1iwx70zhfp6zc2mh74nv26nj4gr3h3am";
  };

  buildInputs = [
     glib
     itstool
     libxml2

     mate.mate-desktop

     vte
     gtk3
     dconf
     pcre2
  ];

  nativeBuildInputs = [
    pkg-config
    gettext
    wrapGAppsHook
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "The MATE Terminal Emulator";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
