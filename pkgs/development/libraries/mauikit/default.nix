{ lib
, mkDerivation
, fetchFromGitLab
, cmake
, extra-cmake-modules
, kio
, qtbase
, qtquickcontrols2
, syntax-highlighting
}:

mkDerivation rec {
  pname = "mauikit";
  version = "1.2.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "maui";
    repo = "mauikit";
    rev = "v${version}";
    sha256 = "1wimbpbn9yqqdcjd59x83z0mw2fycjz09py2rwimfi8ldmvi5lgy";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kio
    qtquickcontrols2
    syntax-highlighting
  ];

  meta = with lib; {
    homepage = "https://mauikit.org/";
    description = "Free and modular front-end framework for developing fast and compelling user experiences";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ dotlambda ];
    broken = lib.versionOlder qtbase.version "5.14.0";
  };
}
