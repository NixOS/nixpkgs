{ mkDerivation
, lib
, fetchFromGitLab
, extra-cmake-modules
, ki18n
, qtlocation
}:

mkDerivation rec {
  pname = "kweathercore";
  version = "21.05";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OAJUtOcs9JJdeOdlkqDch4A4ew3qLK1N12p592e9gn0=";
  };

  buildInputs = [
    ki18n
    qtlocation
  ];

  nativeBuildInputs = [ extra-cmake-modules ];

  meta = with lib; {
    license = [ licenses.cc0 ];
    maintainers = [ maintainers.samueldr ];
    description = ''
      Library to facilitate retrieval of weather information including forecasts and alerts
    '';
  };
}
