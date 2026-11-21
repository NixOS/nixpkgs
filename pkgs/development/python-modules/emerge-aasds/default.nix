{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  writableTmpDirAsHomeHook,
  numpy,
  scipy,
  pytestCheckHook,
  apple-sdk_26,
}:

buildPythonPackage (finalAttrs: {
  pname = "emerge-aasds";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FennisRobert";
    repo = "emerge-aasds";
    rev = "b767d167ae0c7995463960faf72d0aba2abc45bf";
    hash = "sha256-Iw0+1ug2/UW+p0BRuSmpfac570sXn8fIZCtiDuG40Jw=";
  };

  postPatch = ''
    substituteInPlace src/emerge_aasds/_build_wrapper.py \
      --replace-fail 'ARCHS = ("arm64", "x86_64")' 'ARCHS = ("${stdenv.hostPlatform.darwinArch}",)'
    substituteInPlace setup.py \
      --replace-fail 'universal2' '${stdenv.hostPlatform.darwinArch}'
  '';

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
  ];

  build-system = [
    setuptools
  ];

  buildInputs = [
    apple-sdk_26
  ];

  dependencies = [
    numpy
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "emerge_aasds"
  ];

  meta = {
    description = "Python interface for Apple Accelerate Sparse Direct Solver";
    homepage = "https://github.com/FennisRobert/emerge-aasds";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    teams = with lib.teams; [ ngi ];
  };
})
