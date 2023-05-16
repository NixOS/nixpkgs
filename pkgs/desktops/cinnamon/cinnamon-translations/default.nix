{ lib
, stdenv
, fetchFromGitHub
, gettext
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-translations";
<<<<<<< HEAD
  version = "5.8.2";
=======
  version = "5.6.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-hFqCKzJogGka6vsIj8SCL9GMDsTQO50jwpYKr74V5Fo=";
=======
    hash = "sha256-567xkQGLLhZtjAWXzW/MRiD14rrWeg0yvx97jtukRvc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
