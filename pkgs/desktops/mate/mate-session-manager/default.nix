{ stdenv, fetchurl, pkgconfig, gettext, xtrans, dbus-glib, systemd,
  libSM, libXtst, gtk3, epoxy, polkit, hicolor-icon-theme, mate,
  wrapGAppsHook, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "mate-session-manager";
  version = "1.24.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1zwq8symyp3ijs28pyrknsdi9byf4dpp9wp93ndwdhi0vaip5i51";
  };

  patches = [
    # allow turning on debugging from environment variable
    (fetchpatch {
      url = "https://github.com/mate-desktop/mate-session-manager/commit/3ab6fbfc811d00100d7a2959f8bbb157b536690d.patch";
      sha256 = "0yjaklq0mp44clymyhy240kxlw95z3azmravh4f5pfm9dys33sg0";
    })
  ];

  nativeBuildInputs = [
    pkgconfig
    gettext
    xtrans
    wrapGAppsHook
  ];

  buildInputs = [
    dbus-glib
    systemd
    libSM
    libXtst
    gtk3
    mate.mate-desktop
    hicolor-icon-theme
    epoxy
    polkit
  ];

  enableParallelBuilding = true;

  postFixup = ''
    substituteInPlace $out/share/xsessions/mate.desktop \
      --replace "Exec=mate-session" "Exec=$out/bin/mate-session" \
      --replace "TryExec=mate-session" "TryExec=$out/bin/mate-session"
  '';

  passthru.providedSessions = [ "mate" ];

  meta = with stdenv.lib; {
    description = "MATE Desktop session manager";
    homepage = "https://github.com/mate-desktop/mate-session-manager";
    license = with licenses; [ gpl2 lgpl2 ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
