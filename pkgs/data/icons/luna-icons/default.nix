{ stdenv
, fetchFromGitHub
, gtk3
, breeze-icons
, hicolor-icon-theme
, pantheon
}:

stdenv.mkDerivation rec {
  pname = "luna-icons";
  version = "2020-08-09";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = pname;
    rev = "d32aacabcc018212c460833327e1b54a716a5a23";
    sha256 = "1f1ypxcvmd97afn7612i8gxmbrj80vx45vqrrh3n0p65jw5lg7zc";
  };

  nativeBuildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    breeze-icons
    hicolor-icon-theme
    pantheon.elementary-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -a Luna* $out/share/icons

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Icon pack based on marwaita and papirus icons";
    homepage = "https://github.com/darkomarko42/Luna-Icons";
    license = [ licenses.gpl3Only ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
