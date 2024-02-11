{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "graphite-cursors";
  version = "2021-11-26";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "sha256-Kopl2NweYrq9rhw+0EUMhY/pfGo4g387927TZAhI5/A=";
  };

  installPhase = ''
    install -dm 755 $out/share/icons
    mv dist-dark $out/share/icons/graphite-dark
    mv dist-light $out/share/icons/graphite-light
    mv dist-dark-nord $out/share/icons/graphite-dark-nord
    mv dist-light-nord $out/share/icons/graphite-light-nord
  '';

  meta = with lib; {
    description = "Graphite cursor theme";
    homepage = "https://github.com/vinceliuice/Graphite-cursors";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ oluceps ];
  };
}
