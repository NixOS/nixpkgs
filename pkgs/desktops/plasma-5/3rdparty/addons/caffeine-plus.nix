{ lib
, mkDerivation
, fetchFromGitHub
, extra-cmake-modules
, kwindowsystem
, plasma-framework
}:

mkDerivation rec {
  pname = "plasma-applet-caffeine-plus";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "qunxyz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/Nz0kSDGok7GjqSQtjH/8q/u6blVTFPO6kfjEyt/jEo=";
  };

  buildInputs = [
    kwindowsystem
    plasma-framework
  ];

  nativeBuildInputs = [ extra-cmake-modules ];

  cmakeFlags = [
    "-Wno-dev"
  ];

  meta = with lib; {
    description = "Disable screensaver and auto suspend";
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (src.meta) homepage;
    inherit (kwindowsystem.meta) platforms;
  };
}
