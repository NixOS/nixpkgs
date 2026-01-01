{
  lib,
  mkDerivation,
  fetchurl,
  extra-cmake-modules,
  qttools,
}:
mkDerivation rec {
  pname = "kuserfeedback";
  version = "1.3.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-JSMIuCLdRpDqhasWiMmw2lUSl4rGtDX3ell5/B0v/RM=";
  };

  nativeBuildInputs = [
    extra-cmake-modules
    qttools
  ];

<<<<<<< HEAD
  meta = {
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.k900 ];
=======
  meta = with lib; {
    license = [ licenses.mit ];
    maintainers = [ maintainers.k900 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Framework for collecting user feedback for apps via telemetry and surveys";
  };
}
