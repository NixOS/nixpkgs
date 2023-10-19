{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk-engine-murrine
}:

stdenvNoCC.mkDerivation {
  pname = "tokyo-night-gtk";
  version = "unstable-2023-05-30";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Tokyo-Night-GTK-Theme";
    rev = "e9790345a6231cd6001f1356d578883fac52233a";
    hash = "sha256-Q9UnvmX+GpvqSmTwdjU4hsEsYhA887wPqs5pyqbIhmc=";
  };

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cp -a themes/* $out/share/themes
    runHook postInstall
  '';

  meta = with lib; {
    description = "A GTK theme based on the Tokyo Night colour palette.";
    homepage = "www.pling.com/p/1681315/";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with lib.maintainers; [ garaiza-93 ];
  };
}
