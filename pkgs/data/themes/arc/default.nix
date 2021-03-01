{ lib, stdenv
, fetchFromGitHub
, sassc
, autoreconfHook
, pkg-config
, gtk3
, gnome3
, gtk-engine-murrine
, optipng
, inkscape
, cinnamon
}:

stdenv.mkDerivation rec {
  pname = "arc-theme";
  version = "20210127";

  src = fetchFromGitHub {
    owner = "jnsh";
    repo = pname;
    rev = version;
    sha256 = "sha256-P7YZTD5bAWNWepL7qsZZAMf8ujzNbHOj/SLx8Fw3bi4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    sassc
    optipng
    inkscape
    gtk3
  ];

  propagatedUserEnvPkgs = [
    gnome3.gnome-themes-extra
    gtk-engine-murrine
  ];

  enableParallelBuilding = true;

  preBuild = ''
    # Shut up inkscape's warnings about creating profile directory
    export HOME="$NIX_BUILD_ROOT"
  '';

  configureFlags = [
    "--with-cinnamon=${cinnamon.cinnamon-common.version}"
    "--with-gnome-shell=${gnome3.gnome-shell.version}"
    "--disable-unity"
  ];

  postInstall = ''
    install -Dm644 -t $out/share/doc/${pname} AUTHORS *.md
  '';

  meta = with lib; {
    description = "Flat theme with transparent elements for GTK 3, GTK 2 and Gnome Shell";
    homepage = "https://github.com/jnsh/arc-theme";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ simonvandel romildo ];
  };
}
