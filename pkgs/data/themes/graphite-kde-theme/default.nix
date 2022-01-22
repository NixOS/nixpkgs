{ stdenv
, lib
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "graphite-kde-theme";
  version = "unstable-2022-01-22";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "d60a26533b104d6d2251c5187a402f3f35ecbdf7";
    sha256 = "0cry5s3wr0frpchc0hx97r9v6r3v6rvln7l1hb3znn8npkr4mssi";
  };

  installPhase = ''
    runHook preInstall

    patchShebangs install.sh

    substituteInPlace install.sh \
      --replace '$HOME/.local' $out \
      --replace '$HOME/.config' $out/share

    name= ./install.sh --dest $out/share/themes

    mkdir -p $out/share/sddm/themes
    cp -a sddm/Graphite $out/share/sddm/themes/

    runHook postInstall
  '';

  meta = with lib; {
    description = "A flat Design theme for KDE Plasma desktop";
    homepage = "https://github.com/vinceliuice/Graphite-kde-theme";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
