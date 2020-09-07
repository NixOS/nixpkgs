{ stdenv
, fetchFromGitHub
, gdk-pixbuf
, gtk-engine-murrine
, gtk_engines
, librsvg
}:

stdenv.mkDerivation rec {
  pname = "marwaita";
  version = "7.6.1";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = pname;
    rev = version;
    sha256 = "1n7flwrngwh6gmh72j40apf8qk52162m93hsfhgxzrivkhg37zi0";
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
    description = "GTK theme supporting Budgie, Pantheon, Mate, Xfce4 and GNOME desktops";
    homepage = "https://www.pling.com/p/1239855/";
    license = licenses.cc0;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
