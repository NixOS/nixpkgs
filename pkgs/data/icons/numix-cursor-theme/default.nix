{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "20160110";

  package-name = "numix-cursor-theme";

  name = "${package-name}-${version}";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = "e92186d9df47c04d4e0a778eb6941ef58590b179";
    sha256 = "1sr4pisgrn3632phsiny2fyr2ib6l51fnjdsanmh9ampagl4ly7g";
  };

  dontBuild = true;

  installPhase = ''
    install -dm 755 $out/share/icons
    cp -dr --no-preserve='ownership' Numix{,-Light} $out/share/icons/
  '';

  meta = with stdenv.lib; {
    description = "Numix cursor theme";
    homepage = https://numixproject.github.io;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ offline ];
  };
}
