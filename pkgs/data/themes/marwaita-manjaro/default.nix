{
  lib,
  stdenv,
  fetchFromGitHub,
  gdk-pixbuf,
  gtk-engine-murrine,
  gtk_engines,
  librsvg,
}:

stdenv.mkDerivation rec {
  pname = "marwaita-manjaro";
  version = "17.0";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = pname;
    rev = version;
    sha256 = "sha256-lNHzO5wxAFL1axLlxefXyJue0Zu6bM53AUNm74IE4y8=";
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

  meta = with lib; {
    description = "Manjaro Style (green version) of Marwaita GTK theme";
    homepage = "https://www.pling.com/p/1351213/";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
