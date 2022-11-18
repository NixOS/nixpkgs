{ stdenvNoCC
, fetchFromGitHub
, lib
}:

stdenvNoCC.mkDerivation rec {
  pname = "nordzy-cursor-theme";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "alvatip";
    repo = "Nordzy-cursors";
    rev = "v${version}";
    sha256 = "sha256-q9PEEyxejRQ8UCwbqsfOCL7M70pLCOLyCx8gEFmZkWA=";
  };

  installPhase = ''
    mkdir -p $out/share/icons
    cp -r Nordzy-cursors/ $out/share/icons/Nordzy-cursors
    mv $out/share/icons/Nordzy-cursors/index.theme $out/share/icons/Nordzy-cursors/cursor.theme
    cp -r Nordzy-cursors-white/ $out/share/icons/Nordzy-white-cursors
    mv $out/share/icons/Nordzy-white-cursors/index.theme $out/share/icons/Nordzy-white-cursors/cursor.theme
    cp -r Nordzy-cursors-lefthand/ $out/share/icons/Nordzy-cursors-lefthand
    mv $out/share/icons/Nordzy-cursors-lefthand/index.theme $out/share/icons/Nordzy-cursors-lefthand/cursor.theme
  '';

  meta = with lib; {
    description = "Cursor theme using the Nord color palette and based on Vimix and cz-Viator";
    homepage = "https://github.com/alvatip/Nordzy-cursors";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [
      alexnortung
    ];
  };
}
