{ stdenv, fetchFromGitHub, lib
, pkgconfig, autoreconfHook , gtk-doc
, gtkVersion ? "3"
, gtk2, libayatana-indicator-gtk2, libdbusmenu-gtk2
, gtk3, libayatana-indicator-gtk3, libdbusmenu-gtk3
, dbus-glib, python2, python2Packages
}:

stdenv.mkDerivation rec {
  pname = "libayatana-appindicator-gtk${gtkVersion}";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = "libayatana-appindicator";
    rev = version;
    sha256 = "0bqjqb7gabdk7mifk8azi630qw39z978f973fx2ylgdgr4a66j1v";
  };

  patchPhase = ''
    substituteInPlace configure.ac \
      --replace "codegendir pygtk-2.0" "codegendir pygobject-2.0"
  '';

  nativeBuildInputs = [ pkgconfig autoreconfHook gtk-doc ];

  buildInputs = [ dbus-glib python2 python2Packages.pygtk ]
    ++ lib.lists.optional (gtkVersion == "2") libayatana-indicator-gtk2
    ++ lib.lists.optional (gtkVersion == "3") libayatana-indicator-gtk3;

  propagatedBuildInputs =
    lib.lists.optionals (gtkVersion == "2") [ gtk2 libdbusmenu-gtk2 ]
    ++ lib.lists.optionals (gtkVersion == "3") [ gtk3 libdbusmenu-gtk3 ];

  preAutoreconf = ''
    gtkdocize
  '';

  configureFlags = [ "--with-gtk=${gtkVersion}" ];

  meta = with stdenv.lib; {
    description = "Ayatana Application Indicators Shared Library";
    homepage = "https://github.com/AyatanaIndicators/libayatana-appindicator";
    changelog = "https://github.com/AyatanaIndicators/libayatana-appindicator/blob/${version}/ChangeLog";
    license = [ licenses.gpl3 licenses.lgpl21 ];
    maintainers = [ maintainers.nickhu ];
    platforms = platforms.x86_64;
  };
}
