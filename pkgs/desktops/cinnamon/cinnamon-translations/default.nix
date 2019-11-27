{ stdenv, fetchFromGitHub, gettext }:
stdenv.mkDerivation rec {
  pname = "cinnamon-translations";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "0hh6shfj7vc1mw814l38cakfmh135ba8j604h1rmx4zwspwgvgzh";
  };

  nativeBuildInputs = [ gettext ];

  installPhase =
    ''
      mv usr $out # files get installed like so: msgfmt -o usr/share/locale/$lang/LC_MESSAGES/$dir.mo $file
    '';

  meta = {
    homepage = "http://cinnamon.linuxmint.com";
    description = "Translations files for the Cinnamon desktop" ;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.mkg20001 ];
  };
}
