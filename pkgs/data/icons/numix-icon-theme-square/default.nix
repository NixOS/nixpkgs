{ stdenv, fetchFromGitHub, numix-icon-theme }:

stdenv.mkDerivation rec {
  version = "2016-11-23";

  package-name = "numix-icon-theme-square";

  name = "${package-name}-${version}";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = "1c30eb02aea3d95c49f95c212702b56e93ac9043";
    sha256 = "1d2car4dsh1dnim9jlakm035ydqd1f115cagm6zm8gwa5w9annag";
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
