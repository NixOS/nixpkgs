{ lib, stdenvNoCC, fetchFromGitHub, gtk3, breeze-icons, gnome-icon-theme, hicolor-icon-theme }:

stdenvNoCC.mkDerivation rec {
  pname = "gruvbox-plus-icon-pack";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "SylEleuth";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-KefCHHFtuh2wAGBq6hZr9DpuJ0W99ueh8i1K3tohgG8=";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [ breeze-icons gnome-icon-theme hicolor-icon-theme ];

  installPhase = ''
    mkdir -p $out/share/icons/Gruvbox-Plus-Dark
    rm README.md
    cp -r * $out/share/icons/Gruvbox-Plus-Dark
    gtk-update-icon-cache $out/share/icons/Gruvbox-Plus-Dark
  '';

  dontDropIconThemeCache = true;

  meta = with lib; {
    description = "Gruvbox Plus icon pack for Linux desktops based on Gruvbox color theme.";
    homepage = "https://github.com/SylEleuth/gruvbox-plus-icon-pack";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.eureka-cpu ];
  };
}
