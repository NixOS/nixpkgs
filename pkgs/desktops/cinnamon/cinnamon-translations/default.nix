{ stdenv, fetchFromGitHub, gettext }:
stdenv.mkDerivation rec {
  name = "cinnamon-translations";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "${name}";
    rev = "${version}";
    sha256 = "0hh6shfj7vc1mw814l38cakfmh135ba8j604h1rmx4zwspwgvgzh";
  };

  nativeBuildInputs = [ gettext ];

  installPhase =
    ''
      mkdir -pv $out/share/cinnamon/locale
      cp -av "mo-export/"* $out/share/cinnamon/locale/
    '';

  meta = {
    homepage = "http://cinnamon.linuxmint.com";
    description = "Translations files for the Cinnamon desktop" ;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.mkg20001 ];
  };
}
