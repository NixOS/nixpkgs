{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "a704451830d343670721cbf1391df18611d61901";

  package-name = "numix-icon-theme";

  name = "${package-name}-20160120-${version}";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = version;
    sha256 = "0kk0rvywbm074nskjvvy0vjf6giw54jgvrw7sz9kwnv6h75ki96m";
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
