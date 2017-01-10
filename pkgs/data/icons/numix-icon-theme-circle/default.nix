{ stdenv, fetchFromGitHub, numix-icon-theme }:

stdenv.mkDerivation rec {
  version = "2016-11-10";

  package-name = "numix-icon-theme-circle";

  name = "${package-name}-${version}";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = "ba72743b0ee78cf56585bb498eb59e83d0de17a2";
    sha256 = "0zyvcpa8d8jc7r08chhv0chp7z29w6ir9hkgm9aq23aa80i6pdgv";
  };

  buildInputs = [ numix-icon-theme ];

  dontBuild = true;

  installPhase = ''
    install -dm 755 $out/share/icons
    cp -dr --no-preserve='ownership' Numix-Circle{,-Light} $out/share/icons/
  '';

  meta = with stdenv.lib; {
    description = "Numix icon theme (circle version)";
    homepage = https://numixproject.org;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ jgeerds ];
  };
}
