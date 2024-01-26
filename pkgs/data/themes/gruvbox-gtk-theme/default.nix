{ lib
, stdenvNoCC
, fetchFromGitHub
, gnome-themes-extra
, gtk-engine-murrine
}:
stdenvNoCC.mkDerivation {
  pname = "gruvbox-gtk-theme";
  version = "unstable-2023-05-26";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Gruvbox-GTK-Theme";
    rev = "c0b7fb501938241a3b6b5734f8cb1f0982edc6b4";
    hash = "sha256-Y+6HuWaVkNqlYc+w5wLkS2LpKcDtpeOpdHnqBmShm5Q=";
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
