{ stdenv
, fetchFromGitHub
, sassc
, autoreconfHook
, pkgconfig
, gtk3
, gnome3
, gtk-engine-murrine
, optipng
, inkscape_0
}:

stdenv.mkDerivation rec {
  pname = "arc-theme";
  version = "20200513";

  src = fetchFromGitHub {
    owner = "jnsh";
    repo = pname;
    rev = version;
    sha256 = "1xiaf31v3j040hflhf09kpznc93a5fqs92m5jf79y46w3dgpia0p";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
    sassc
    optipng
    inkscape_0
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
    "--with-gnome-shell=${gnome3.gnome-shell.version}"
    "--disable-cinnamon" # not equipped to test
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
