{ stdenv
, fetchFromGitHub
, sassc
, autoreconfHook
, pkgconfig
, gtk3
, gnome3
, gtk-engine-murrine
, optipng
, inkscape
, cinnamon
}:

stdenv.mkDerivation rec {
  pname = "arc-theme";
  version = "20200819";

  src = fetchFromGitHub {
    owner = "jnsh";
    repo = pname;
    rev = version;
    sha256 = "1l5sc4r5jp3526r4p32fszny0cw6pkb45cp424hq0s0k344z9px6";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
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

  meta = with stdenv.lib; {
    description = "Flat theme with transparent elements for GTK 3, GTK 2 and Gnome Shell";
    homepage = "https://github.com/jnsh/arc-theme";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ simonvandel romildo ];
  };
}
