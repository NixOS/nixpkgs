{ lib, stdenv, fetchurl, gtk3, gnome, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "humanity-icon-theme";
  version = "0.6.15";

  src = fetchurl {
    url = "https://launchpad.net/ubuntu/+archive/primary/+files/${pname}_${version}.tar.xz";
    sha256 = "19ja47468s3jfabvakq9wknyfclfr31a9vd11p3mhapfq8jv9g4x";
  };

  nativeBuildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    gnome.adwaita-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -a Humanity* $out/share/icons
    rm $out/share/icons/*/{AUTHORS,CONTRIBUTORS,COPYING}

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Humanity icons from Ubuntu";
    homepage = "https://launchpad.net/humanity/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
