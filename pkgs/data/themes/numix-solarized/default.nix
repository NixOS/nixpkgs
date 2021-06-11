{ lib, stdenv, fetchFromGitHub, python3, sassc, glib, gdk-pixbuf, inkscape, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "numix-solarized-gtk-theme";
  version = "20210522";

  src = fetchFromGitHub {
    owner = "Ferdi265";
    repo = pname;
    rev = version;
    sha256 = "0hin73fmfir4w1z0j87k5hahhf2blhcq4r7gf89gz4slnl18cvjh";
  };

  nativeBuildInputs = [ python3 sassc glib gdk-pixbuf inkscape ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  postPatch = ''
    patchShebangs .
    substituteInPlace Makefile --replace '$(DESTDIR)'/usr $out
  '';

  buildPhase = "true";

  installPhase = ''
    runHook preInstall
    for theme in *.colors; do
      make THEME="''${theme/.colors/}" install
    done
    runHook postInstall
  '';

  meta = with lib; {
    description = "Solarized versions of Numix GTK2 and GTK3 theme";
    longDescription = ''
      This is a fork of the Numix GTK theme that replaces the colors of the theme
      and icons to use the solarized theme with a solarized green accent color.
      This theme supports both the dark and light theme, just as Numix proper.
    '';
    homepage = "https://github.com/Ferdi265/numix-solarized-gtk-theme";
    downloadPage = "https://github.com/Ferdi265/numix-solarized-gtk-theme/releases";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.offline ];
  };
}
