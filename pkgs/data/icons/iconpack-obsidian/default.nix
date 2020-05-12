{ stdenv, fetchFromGitHub, gtk3, gnome-icon-theme, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "iconpack-obsidian";
  version = "4.11";

  src = fetchFromGitHub {
    owner = "madmaxms";
    repo = pname;
    rev = "v${version}";
    sha256 = "18sqnrvh4bbmg3zzm78n4s2hvv8a77ilg7xa3hl94mp9qla6gasn";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [ gnome-icon-theme hicolor-icon-theme ];
  # still missing parent themes: Ambiant-MATE, Mint-X, Faenza-Dark, KFaenza

  dontDropIconThemeCache = true;

  installPhase = ''
    mkdir -p $out/share/icons
    mv Obsidian* $out/share/icons

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
