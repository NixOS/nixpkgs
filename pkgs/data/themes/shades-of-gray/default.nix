{ stdenv, fetchFromGitHub, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "shades-of-gray-theme-${version}";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "WernerFP";
    repo = "Shades-of-gray-theme";
    rev = version;
    sha256 = "14p1s1pmzqnn9j9vwqfxfd4i045p356a6d9rwzzs0gx3c6ibqx3a";
  };

  buildInputs = [ gtk_engines ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    mkdir -p $out/share/themes
    cp -a Shades-of-gray* $out/share/themes/
  '';

  meta = with stdenv.lib; {
    description = "A flat dark GTK-theme with ergonomic contrasts";
    homepage = https://github.com/WernerFP/Shades-of-gray-theme;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
