{ lib
, stdenv
, fetchFromGitHub
, gettext
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-translations";
  version = "5.6.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-567xkQGLLhZtjAWXzW/MRiD14rrWeg0yvx97jtukRvc=";
  };

  nativeBuildInputs = [
    gettext
  ];

  installPhase = ''
    mv usr $out # files get installed like so: msgfmt -o usr/share/locale/$lang/LC_MESSAGES/$dir.mo $file
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/cinnamon-translations";
    description = "Translations files for the Cinnamon desktop";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
