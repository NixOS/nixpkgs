{ lib
, stdenvNoCC
, fetchFromGitHub
, gnome-themes-extra
, gtk-engine-murrine
}:
stdenvNoCC.mkDerivation rec {
  pname = "gruvbox-gtk-theme";
  version = "unstable-2022-12-09";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Gruvbox-GTK-Theme";
    rev = "c3172d8dcba66f4125a014d280d41e23f0b95cad";
    sha256 = "1411mjlcj1d6kw3d3h1w9zsr0a08bzl5nddkkbv7w7lf67jy9b22";
  };

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  buildInputs = [
    gnome-themes-extra
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cp -a themes/* $out/share/themes
    runHook postInstall
  '';

  meta = with lib; {
    description = "A Gtk theme based on the Gruvbox colour pallete";
    homepage = "https://www.pling.com/p/1681313/";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.math-42 ];
  };
}
