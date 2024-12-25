{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  breeze-icons,
  gnome-icon-theme,
  hicolor-icon-theme,
}:

stdenvNoCC.mkDerivation rec {
  pname = "gruvbox-dark-icons-gtk";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "jmattheis";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fks2rrrb62ybzn8gqan5swcgksrb579vk37bx4xpwkc552dz2z2";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [
    breeze-icons
    gnome-icon-theme
    hicolor-icon-theme
  ];

  installPhase = ''
    mkdir -p $out/share/icons/oomox-gruvbox-dark
    rm README.md
    cp -r * $out/share/icons/oomox-gruvbox-dark
    gtk-update-icon-cache $out/share/icons/oomox-gruvbox-dark
  '';

  dontDropIconThemeCache = true;

  meta = with lib; {
    description = "Gruvbox icons for GTK based desktop environments";
    homepage = "https://github.com/jmattheis/gruvbox-dark-gtk";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.nomisiv ];
  };
}
