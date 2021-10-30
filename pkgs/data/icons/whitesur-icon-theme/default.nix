{ lib, stdenvNoCC, fetchFromGitHub, gtk3, hicolor-icon-theme }:

stdenvNoCC.mkDerivation rec {
  pname = "Whitesur-icon-theme";
  version = "2021-10-13";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "BP5hGi3G9zNUSfeCbwYUvd3jMcWhstXiDeZCJ6Hgey8=";
  };

  nativeBuildInputs = [ gtk3 ];

  buildInputs = [ hicolor-icon-theme ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/WhiteSur{,-dark}/status
    echo "$out/share/icons/WhiteSur/status $out/share/icons/WhiteSur-dark/status" | xargs -n 1 cp -r src/status/{16,22,24,32,symbolic}
    echo "$out/share/icons/WhiteSur $out/share/icons/WhiteSur-dark" | xargs -n 1 cp -r ./{COPYING,AUTHORS} src/index.theme src/{actions,animations,apps,categories,devices,emblems,mimes,places} links/{actions,apps,categories,devices,emblems,mimes,places,status}

    # Change icon color for dark theme
    sed -i "s/#363636/#dedede/g" $out/share/icons/WhiteSur-dark/{actions,devices,places,status}/{16,22,24}/*
    sed -i "s/#363636/#dedede/g" $out/share/icons/WhiteSur-dark/actions/32/*
    sed -i "s/#363636/#dedede/g" $out/share/icons/WhiteSur-dark/{actions,apps,categories,emblems,devices,mimes,places,status}/symbolic/*

    for f in actions animations apps categories devices emblems mimes places status; do
      ln -sf $out/share/icons/WhiteSur/$f $out/share/icons/WhiteSur/$f@2x
      ln -sf $out/share/icons/WhiteSur-dark/$f $out/share/icons/WhiteSur-dark/$f@2x
    done

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "MacOS Big Sur style icon theme for Linux desktops";
    homepage = "https://github.com/vinceliuice/WhiteSur-icon-theme";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ icy-thought ];
  };

}
