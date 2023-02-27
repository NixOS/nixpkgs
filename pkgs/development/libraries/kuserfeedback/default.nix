{ lib
, mkDerivation
, fetchurl
, extra-cmake-modules
, qttools
}:
mkDerivation rec {
  pname = "kuserfeedback";
  version = "1.2.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-dqrJIrFTJJsnRoCm9McsI47xTj3wS60Ay2QVixBj8mQ=";
  };

  nativeBuildInputs = [ extra-cmake-modules qttools ];

  meta = with lib; {
    license = [ licenses.mit ];
    maintainers = [ maintainers.k900 ];
    description = "Framework for collecting user feedback for apps via telemetry and surveys";
  };
}
