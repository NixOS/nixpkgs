{ mkDerivation
, lib
, fetchFromGitLab
, extra-cmake-modules
, ki18n
, qtlocation
}:

mkDerivation rec {
  pname = "kweathercore";
  version = "0.5";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = pname;
    rev = "v${version}";
    sha256 = "08ipabskhsbspkzzdlpwl89r070q8d0vc9500ma6d5i9fnpmkz6d";
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
