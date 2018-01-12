{ stdenv, fetchFromGitHub, numix-icon-theme }:

stdenv.mkDerivation rec {
  name = "${package-name}-${version}";
  package-name = "numix-icon-theme-square";
  version = "17-12-25";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = version;
    sha256 = "07rcfkz3c1z5fwqiib4r1bm964mpwf1f128xm8kz55xp6w1c7zgl";
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
