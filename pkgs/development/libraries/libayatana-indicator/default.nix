{ stdenv, fetchFromGitHub, lib
, pkgconfig, autoreconfHook
, gtkVersion ? "3"
, gtk2
, gtk3
, ayatana-ido
}:

stdenv.mkDerivation rec {
  pname = "libayatana-indicator-gtk${gtkVersion}";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = "libayatana-indicator";
    rev = version;
    sha256 = "1q9wmaw6pckwyrv0s7wkqzm1yrk031pbz4xbr8cwn75ixqyfcb28";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];

  buildInputs = [ ayatana-ido ]
    ++ lib.lists.optionals (gtkVersion == "2") [ gtk2 ]
    ++ lib.lists.optionals (gtkVersion == "3") [ gtk3 ];

  configureFlags = [ "--with-gtk=${gtkVersion}" ];

  meta = with stdenv.lib; {
    description = "Ayatana Indicators Shared Library";
    homepage = "https://github.com/AyatanaIndicators/libayatana-indicator";
    changelog = "https://github.com/AyatanaIndicators/libayatana-indicator/blob/${version}/ChangeLog";
    license = licenses.gpl3;
    maintainers = [ maintainers.nickhu ];
    platforms = platforms.x86_64;
  };
}
