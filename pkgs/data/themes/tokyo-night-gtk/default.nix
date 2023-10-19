{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk-engine-murrine
}:

stdenvNoCC.mkDerivation {
  pname = "tokyo-night-gtk";
  version = "2023.01.17";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Tokyo-Night-GTK-Theme";
    rev = "f7ae3421ac0d415ca57fb6224e093e12b8a980bb";
    sha256 = "sha256-90V55pRfgiaP1huhD+3456ziJ2EU24iNQHt5Ro+g+M0=";
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
