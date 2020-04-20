{ stdenv, fetchFromGitHub, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "shades-of-gray-theme";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "WernerFP";
    repo = pname;
    rev = version;
    sha256 = "153isyxly7nvivaz87zk2v1bqzcb3wk0j9vhgxzcz6qkf754q61s";
  };

  buildInputs = [ gtk_engines ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    mkdir -p $out/share/themes
    cp -a Shades-of-gray* $out/share/themes/
  '';

  meta = with stdenv.lib; {
    description = "Flat dark GTK theme with ergonomic contrasts";
    homepage = "https://github.com/WernerFP/Shades-of-gray-theme";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
