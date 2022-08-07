{ stdenvNoCC
, fetchFromGitHub
, lib
}:

stdenvNoCC.mkDerivation rec {
  pname = "nordzy-cursor-theme";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "alvatip";
    repo = "Nordzy-cursors";
    rev = "v${version}";
    sha256 = "XabfKFyeII7Xl+ozzpPnc4xFH4B7GzCTLq4M1QPSZPw=";
  };

  installPhase = ''
    mkdir -p $out/share/icons

    cp -r nordzy-dark/ $out/share/icons/Nordzy-cursors
    mv $out/share/icons/Nordzy-cursors/index.theme $out/share/icons/Nordzy-cursors/cursor.theme
    mv $out/share/icons/Nordzy-cursors/Nordzy-cursors $out/share/icons/Nordzy-cursors/cursors
    cp -r nordzy-white/ $out/share/icons/Nordzy-white-cursors
    mv $out/share/icons/Nordzy-white-cursors/index.theme $out/share/icons/Nordzy-white-cursors/cursor.theme
    mv $out/share/icons/Nordzy-white-cursors/Nordzy-white-cursors $out/share/icons/Nordzy-white-cursors/cursors
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
