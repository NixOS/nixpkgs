{ stdenv, fetchFromGitHub, python3, sassc, glib, gdk-pixbuf, inkscape, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  version = "20200910";
  pname = "numix-solarized-gtk-theme";

  src = fetchFromGitHub {
    owner = "Ferdi265";
    repo = "numix-solarized-gtk-theme";
    rev = version;
    sha256 = "05h1563sy6sfz76jadxsf730mav6bbjsk9xnadv49r16b8n8p9a9";
  };

  nativeBuildInputs = [ python3 sassc glib gdk-pixbuf inkscape ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  postPatch = ''
    patchShebangs .
    substituteInPlace Makefile --replace '$(DESTDIR)'/usr $out
  '';

  buildPhase = "true";

  installPhase = ''
    HOME="$NIX_BUILD_ROOT"  # shut up inkscape's warnings
    for theme in *.colors; do
      make THEME="''${theme/.colors/}" install
    done
  '';

  meta = with stdenv.lib; {
    description = "Solarized versions of Numix GTK2 and GTK3 theme";
    longDescription = ''
      This is a fork of the Numix GTK theme that replaces the colors of the theme
      and icons to use the solarized theme with a solarized green accent color.
      This theme supports both the dark and light theme, just as Numix proper.
    '';
    homepage = "https://github.com/Ferdi265/numix-solarized-gtk-theme";
    downloadPage = "https://github.com/Ferdi265/numix-solarized-gtk-theme/releases";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.offline ];
  };
}
