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

stdenv.mkDerivation (finalAttrs: {
  pname = "crocoddyl";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "loco-3d";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-MsAXHfxLNlIK/PbtVTjvBN1Jk3dyGEkfpj3/98nExj4=";
  };

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

  prePatch = ''
    substituteInPlace \
      examples/CMakeLists.txt \
      examples/log/check_logfiles.sh \
      --replace /bin/bash ${stdenv.shell}
  '';

  doCheck = true;
  pythonImportsCheck = [
    "crocoddyl"
  ];
  checkInputs = lib.optionals (pythonSupport) [
    python3Packages.scipy
  ];

  meta = with lib; {
    description = "Crocoddyl optimal control library";
    homepage = "https://github.com/loco-3d/crocoddyl";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nim65s wegank ];
    platforms = platforms.unix;
  };
})
