{ fetchFromGitHub
, lib, stdenv
, gnome
, gnome-icon-theme
, hicolor-icon-theme
, gtk3
, humanity-icon-theme
, ubuntu-themes
}:

stdenv.mkDerivation rec {
  pname = "mint-x-icons";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    # commit is named 1.5.5, tags=404
    rev = "ecfbeb62bba41e85a61099df467c4700ac63c1e0";
    sha256 = "1yxm7h7giag5hmymgxsg16vc0rhxb2vn3piaksc463mic4vwfa3i";
  };

  propagatedBuildInputs = [
    gnome.adwaita-icon-theme
    gnome-icon-theme
    hicolor-icon-theme
    humanity-icon-theme
    ubuntu-themes # provides ubuntu-mono-dark
  ];

  nativeBuildInputs = [
    gtk3
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv usr/share $out

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/mint-x-icons";
    description = "Mint/metal theme based on mintified versions of Clearlooks Revamp, Elementary and Faenza";
    license = licenses.gpl3Plus; # from debian/copyright
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
