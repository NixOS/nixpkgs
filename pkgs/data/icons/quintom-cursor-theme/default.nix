{ stdenvNoCC, fetchFromGitLab, lib }:

stdenvNoCC.mkDerivation {
  pname = "quintom-cursor-theme";
  version = "unstable-2019-10-24";

  src = fetchFromGitLab {
    owner = "Burning_Cube";
    repo = "quintom-cursor-theme";
    rev = "d23e57333e816033cf20481bdb47bb1245ed5d4d";
    hash = "sha256-Sec2DSnWYal6wzYzP9W+DDuTKHsFHWdRYyMzliMU5bU=A";
  };

  installPhase = ''
    mkdir -p $out/share/icons
    for theme in "Quintom_Ink" "Quintom_Snow"; do
      cp -r "$theme Cursors/$theme" $out/share/icons/
    done
  '';

  meta = with lib; {
    description = "A cursor theme designed to look decent";
    homepage = "https://gitlab.com/Burning_Cube/quintom-cursor-theme";
    platforms = platforms.unix;
    license = with licenses; [ cc-by-sa-40 gpl3Only ];
    maintainers = with maintainers; [ frogamic ];
  };
}
