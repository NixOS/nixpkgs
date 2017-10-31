{ stdenv, fetchFromGitHub, numix-icon-theme }:

stdenv.mkDerivation rec {
  name = "${package-name}-${version}";
  package-name = "numix-icon-theme-square";
  version = "17-09-13";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = version;
    sha256 = "1grpm902hiid561fbp9y1rb9z21y8d1krjgxgs7j8qnpx380sd5x";
  };

  buildInputs = [ numix-icon-theme ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/icons
    cp -a Numix-Square{,-Light} $out/share/icons/
  '';

  meta = with stdenv.lib; {
    description = "Numix icon theme (square version)";
    homepage = https://numixproject.org;
    license = licenses.gpl3;
    platforms = with platforms; allBut darwin;
    maintainers = with maintainers; [ romildo ];
  };
}
