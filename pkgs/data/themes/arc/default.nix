{ stdenv
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
  version = "20201013";

  src = fetchFromGitHub {
    owner = "jnsh";
    repo = pname;
    rev = version;
    sha256 = "1x2l1mwjx68dwf3jb1i90c1q8nqsl1wf2zggcn8im6590k5yv39s";
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

  meta = with stdenv.lib; {
    description = "Flat theme with transparent elements for GTK 3, GTK 2 and Gnome Shell";
    homepage = "https://github.com/jnsh/arc-theme";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ simonvandel romildo ];
  };
}
