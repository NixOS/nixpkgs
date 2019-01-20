{ stdenv, fetchFromGitHub, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "shades-of-gray-theme-${version}";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "WernerFP";
    repo = "Shades-of-gray-theme";
    rev = version;
    sha256 = "1i5mra1ib3c8xqnhwjh8yzjcdnhvqdmccw5x52sfh9xq797px39l";
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
