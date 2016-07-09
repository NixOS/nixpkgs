{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2016-06-10";

  package-name = "numix-icon-theme";

  name = "${package-name}-${version}";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = "8196e9eaa5a60b5c02a9e37a4ca768b07966b41f";
    sha256 = "0cyv0r66vil54y6w317msddq2fjs9zhrdx17m3bx85xpqz67zq5i";
  };

  dontBuild = true;

  installPhase = ''
    install -dm 755 $out/share/icons
    cp -dr --no-preserve='ownership' Numix{,-Light} $out/share/icons/
  '';

  meta = with stdenv.lib; {
    description = "Numix icon theme";
    homepage = https://numixproject.org;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ romildo jgeerds ];
  };
}
