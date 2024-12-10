{
  lib,
  stdenv,
  fetchFromGitHub,
  gdk-pixbuf,
  gtk-engine-murrine,
  gtk_engines,
  librsvg,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "marwaita-peppermint";
  version = "17.0";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = pname;
    rev = "247f9c539d6eef8ae3a5f59beed42a40b1f10434";
    hash = "sha256-uT7KnpIdxypUqKhXOao3Bz3vJecJKK+GjcAp9biNyHc=";
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
    description = "Marwaita GTK theme with Peppermint Os Linux style";
    homepage = "https://www.pling.com/p/1399569/";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
