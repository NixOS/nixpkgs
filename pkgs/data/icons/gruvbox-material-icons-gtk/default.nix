{ lib
, stdenv
, fetchFromGitHub
, gtk3
, gtk-engine-murrine
, hicolor-icon-theme
, breeze-icons
}:

stdenv.mkDerivation rec {
  pname = "gruvbox-material-gtk";
  version = "unstable-2021-07-25";

  src = fetchFromGitHub {
    owner = "TheGreatMcPain";
    repo = pname;
    rev = "cc255d43322ad646bb35924accb0778d5e959626";
    sha256 = "sha256-1O34p9iZelqRFBloOSZkxV0Z/7Jffciptpj3fwXPHbc=";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [ breeze-icons hicolor-icon-theme ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r icons/Gruvbox-Material-Dark $out/share/icons
    gtk-update-icon-cache $out/share/icons/Gruvbox-Material-Dark

    runHook postInstall
  '';

  meta = with lib; {
    description = "Gruvbox material icons for GTK based desktop environments";
    homepage = "https://github.com/TheGreatMcPain/gruvbox-material-gtk";
    license = licenses.mit;
    maintainers = [ maintainers.xerbalind ];
  };
}

