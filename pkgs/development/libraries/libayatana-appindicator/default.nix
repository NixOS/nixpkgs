{ stdenv, fetchFromGitHub, lib
, pkg-config, autoreconfHook , gtk-doc
, gobject-introspection
, gtkVersion ? "3"
, gtk2, libayatana-indicator-gtk2, libdbusmenu-gtk2
, gtk3, libayatana-indicator-gtk3, libdbusmenu-gtk3
, dbus-glib,
}:

stdenv.mkDerivation rec {
  pname = "libayatana-appindicator-gtk${gtkVersion}";
  version = "0.5.5";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = "libayatana-appindicator";
    rev = version;
    sha256 = "1sba0w455rdkadkhxrx4fr63m0d9blsbb1q1hcshxw1k1z2nh1gk";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook gtk-doc gobject-introspection dbus-glib ];

  buildInputs =
    lib.optional (gtkVersion == "2") libayatana-indicator-gtk2
    ++ lib.optional (gtkVersion == "3") libayatana-indicator-gtk3;

  propagatedBuildInputs =
    lib.optionals (gtkVersion == "2") [ gtk2 libdbusmenu-gtk2 ]
    ++ lib.optionals (gtkVersion == "3") [ gtk3 libdbusmenu-gtk3 ];

  preAutoreconf = ''
    gtkdocize
  '';

  configureFlags = [ "--with-gtk=${gtkVersion}" ];

  meta = with lib; {
    description = "Ayatana Application Indicators Shared Library";
    homepage = "https://github.com/AyatanaIndicators/libayatana-appindicator";
    changelog = "https://github.com/AyatanaIndicators/libayatana-appindicator/blob/${version}/ChangeLog";
    license = [ licenses.lgpl3Plus licenses.lgpl21Plus ];
    maintainers = [ maintainers.nickhu ];
    platforms = platforms.linux;
  };
}
