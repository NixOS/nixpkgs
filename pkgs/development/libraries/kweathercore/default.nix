{ mkDerivation
, lib
, fetchFromGitLab
, extra-cmake-modules
, ki18n
, qtlocation
}:

mkDerivation rec {
  pname = "kweathercore";
  version = "0.4";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mwmkr1xg0mcgbjgzp04chf55xyrgf0gndg3hs4c21bfjpy1gp3k";
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
