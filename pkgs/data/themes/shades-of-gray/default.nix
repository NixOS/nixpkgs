{ stdenv, fetchFromGitHub, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "shades-of-gray-theme";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "WernerFP";
    repo = pname;
    rev = version;
    sha256 = "09r26izbx9sj9czc95cn4r0c1v9yj2qm84zdl047fiqa49czwbzq";
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
