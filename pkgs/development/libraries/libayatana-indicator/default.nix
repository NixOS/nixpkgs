{ stdenv, fetchFromGitHub, lib
, pkg-config, autoreconfHook
, gtkVersion ? "3"
, gtk2
, gtk3
, ayatana-ido
}:

stdenv.mkDerivation rec {
  pname = "libayatana-indicator-gtk${gtkVersion}";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = "libayatana-indicator";
    rev = version;
    sha256 = "1wlqm3pj12vgz587a72widbg0vcmm1klsd2lh3mpzfy20m3vjxhj";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  buildInputs = [ ayatana-ido ]
    ++ lib.optionals (gtkVersion == "2") [ gtk2 ]
    ++ lib.optionals (gtkVersion == "3") [ gtk3 ];

  configureFlags = [ "--with-gtk=${gtkVersion}" ];

  meta = with lib; {
    description = "Ayatana Indicators Shared Library";
    homepage = "https://github.com/AyatanaIndicators/libayatana-indicator";
    changelog = "https://github.com/AyatanaIndicators/libayatana-indicator/blob/${version}/ChangeLog";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.nickhu ];
    platforms = platforms.linux;
  };
}
