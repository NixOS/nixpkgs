{ stdenv, fetchFromGitHub, numix-icon-theme }:

stdenv.mkDerivation rec {
  version = "17-12-25";

  package-name = "numix-icon-theme-circle";

  name = "${package-name}-${version}";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = version;
    sha256 = "10sn2w9xzmh7arbw0vn516p9nfym1bs8bf7i8zzvz7y09s61lkxh";
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
