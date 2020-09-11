{ stdenv
, fetchFromGitHub
, gdk-pixbuf
, gtk-engine-murrine
, gtk_engines
, librsvg
}:

stdenv.mkDerivation rec {
  pname = "marwaita-manjaro";
  version = "2020-08-29";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = pname;
    rev = "d97e852931732ae5134784d11b332eadd71b6bbf";
    sha256 = "1qa2mlc6k82i4fkgbkahjz3fhghcf8rx1ayxw0r4xl21mkna7bfy";
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
    description = "Manjaro Style (green version) of Marwaita GTK theme";
    homepage = "https://www.pling.com/p/1351213/";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
