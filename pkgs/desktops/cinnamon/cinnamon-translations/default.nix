{ lib
, stdenv
, fetchFromGitHub
, gettext
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-translations";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-qBLg0z0ZoS7clclKsIxMG6378Q1iv1NnhS9cz3f4cEc=";
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
