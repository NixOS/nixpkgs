{ stdenv, fetchFromGitHub, gtk3, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "iconpack-obsidian";
  version = "4.10";

  src = fetchFromGitHub {
    owner = "madmaxms";
    repo = pname;
    rev = "v${version}";
    sha256 = "1imnbfrmizs0yx2165qj423y3m5vw9z33pqxmvhvs0rcwwddgqix";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [ hicolor-icon-theme ];

  dontDropIconThemeCache = true;

  installPhase = ''
     mkdir -p $out/share/icons
     mv Obsidian* $out/share/icons
  '';

  postFixup = ''
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with stdenv.lib; {
    description = "Gnome icon pack based upon Faenza";
    homepage = "https://github.com/madmaxms/iconpack-obsidian";
    license = licenses.lgpl3;
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
