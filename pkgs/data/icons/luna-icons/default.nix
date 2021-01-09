{ stdenv
, fetchFromGitHub
, gtk3
, breeze-icons
, hicolor-icon-theme
, pantheon
}:

stdenv.mkDerivation rec {
  pname = "luna-icons";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = pname;
    rev = version;
    sha256 = "0mz5cayjgsc109nv7kdkn3gn1n79bl3hb773lrzrr0k2zblxg353";
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

    # remove files with spaces in the name, otherwise
    # gtk-update-icon-cache fails with the message "The generated cache
    # was invalid"
    # https://github.com/darkomarko42/Luna-Icons/issues/2
    rm "$out/share/icons/Luna/scalable/apps/yast-checkmedia (copia).svg"

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache "$theme"
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
