{ stdenv
, fetchFromGitHub
, gdk-pixbuf
, gtk-engine-murrine
, gtk_engines
, librsvg
}:

stdenv.mkDerivation rec {
  pname = "marwaita";
  version = "7.5.1";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = pname;
    rev = version;
    sha256 = "0ig5wc6dkbly6yrvd13h4lyr8x0y7k3d9iv4rhg0pnjgcpna83mw";
  };

  buildInputs = [
    gdk-pixbuf
    gtk_engines
    librsvg
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cp -a Marwaita* $out/share/themes
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "GTK theme supporting Budgie, Pantheon, Mate and Xfce4 desktops";
    homepage = "https://www.pling.com/p/1239855/";
    license = licenses.cc0;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
