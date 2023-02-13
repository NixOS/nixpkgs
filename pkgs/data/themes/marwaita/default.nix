{ lib
, stdenv
, fetchFromGitHub
, gdk-pixbuf
, gtk-engine-murrine
, gtk_engines
, librsvg
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "marwaita";
  version = "16.2";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = pname;
    rev = version;
    sha256 = "sha256-jhcmFrTZgWChNvZofLSQzGvOj/U2UqaQ0Cq5sv4UAxE=";
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

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "GTK theme supporting Budgie, Pantheon, Mate, Xfce4 and GNOME desktops";
    homepage = "https://www.pling.com/p/1239855/";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
