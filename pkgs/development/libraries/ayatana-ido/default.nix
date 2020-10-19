{ stdenv, fetchFromGitHub
, pkg-config, autoreconfHook
, gtk3, gobject-introspection, gtk-doc, vala
}:

stdenv.mkDerivation rec {
  pname = "ayatana-ido";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = pname;
    rev = version;
    sha256 = "1jmdvvgrgicpnpnygc24qcisqb9y026541gb6lw6fwapvc9aj73p";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook gtk-doc vala gobject-introspection ];

  buildInputs = [ gtk3 ];

  meta = with stdenv.lib; {
    description = "Ayatana Display Indicator Objects";
    homepage = "https://github.com/AyatanaIndicators/ayatana-ido";
    changelog = "https://github.com/AyatanaIndicators/ayatana-ido/blob/${version}/ChangeLog";
    license = [ licenses.lgpl3Plus licenses.lgpl21Plus ];
    maintainers = [ maintainers.nickhu ];
    platforms = platforms.linux;
  };
}
