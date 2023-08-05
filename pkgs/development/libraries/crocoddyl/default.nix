{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, example-robot-data
, pinocchio
, pythonSupport ? false
, python3Packages
}:

stdenv.mkDerivation rec {
  pname = "crocoddyl";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "loco-3d";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-wDHCHTJXmJjU7mhQ2huUVdEc9ap7PMeqlHPrKm//jBQ=";
  };

  patches = [
    # error: no matching function for call to 'max(double&, int)'
    (fetchpatch {
      url = "https://github.com/loco-3d/crocoddyl/commit/d2e4116257595317740975e745739bb76b92e5c0.patch";
      hash = "sha256-M79jNdIxzx9PfW3TStRny76dVo/HDf/Rp08ZPx+ymBg";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = lib.optionals (!pythonSupport) [
    example-robot-data
    pinocchio
  ] ++ lib.optionals pythonSupport [
    python3Packages.example-robot-data
    python3Packages.pinocchio
  ];

  cmakeFlags = lib.optionals (!pythonSupport) [
    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_PYTHON_INTERFACE=OFF"
  ];

  meta = with lib; {
    description = "Crocoddyl optimal control library";
    homepage = "https://github.com/loco-3d/crocoddyl";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
  };
}
