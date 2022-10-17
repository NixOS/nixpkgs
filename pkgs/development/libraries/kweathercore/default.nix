{ mkDerivation
, lib
, fetchFromGitLab
, extra-cmake-modules
, kholidays
, ki18n
, qtlocation
}:

mkDerivation rec {
  pname = "kweathercore";
  version = "0.6";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-LIgUSXKHcRqcBwGTRxU5Z4eHuWmPLerorlrnI6Cf9k4=";
  };

  buildInputs = [
    kholidays
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
