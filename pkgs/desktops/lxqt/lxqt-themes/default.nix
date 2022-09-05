{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, lxqt-build-tools
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "lxqt-themes";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "OEl6ZfMKdqjONRA1LPZ69KyFjp1c21Uib/riYDWSRWE=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-themes";
    description = "Themes, graphics and icons for LXQt";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.lxqt.members;
  };
}
