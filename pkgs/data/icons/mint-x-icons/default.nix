{ stdenv
, fetchurl
, gnome-icon-theme
, gtk3
, hicolor-icon-theme
, humanity-icon-theme
, ubuntu-themes
}:

stdenv.mkDerivation rec {
  pname = "mint-x-icons";
  version = "1.5.5";

  src = fetchurl {
    url = "http://packages.linuxmint.com/pool/main/m/${pname}/${pname}_${version}.tar.xz";
    sha256 = "0nq3si06m98b71f33wism0bvlvib57rm96msf0wx852ginw3a5yd";
  };

  nativeBuildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    gnome-icon-theme
    hicolor-icon-theme
    humanity-icon-theme
    ubuntu-themes # provides the  parent icon theme: ubuntu-mono-dark
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -vai usr/share/icons/* $out/share/icons

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Mint/metal theme based on mintified versions of Clearlooks Revamp, Elementary and Faenza";
    homepage = "https://github.com/linuxmint/mint-x-icons";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
