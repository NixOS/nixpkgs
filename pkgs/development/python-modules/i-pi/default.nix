{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  gfortran,
  makeWrapper,
  setuptools,
  numpy,
  scipy,
  distutils,
  pytestCheckHook,
  mock,
  pytest-mock,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "i-pi";
  version = "3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "i-pi";
    repo = "i-pi";
    rev = "refs/tags/v${version}";
    hash = "sha256-SJ0qTwwdIOR1nXs9MV6O1oxJPR6/6H86wscDy/sLc/g=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    gfortran
    makeWrapper
  ];

  dependencies = [
    numpy
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    pytest-mock
  ] ++ lib.optional (pythonAtLeast "3.12") distutils;

  pytestFlagsArray = [ "ipi_tests/unit_tests" ];

  postFixup = ''
    wrapProgram $out/bin/i-pi \
      --set IPI_ROOT $out
  '';

  meta = with lib; {
    description = "Universal force engine for ab initio and force field driven (path integral) molecular dynamics";
    license = with licenses; [
      gpl3Only
      mit
    ];
    homepage = "http://ipi-code.org/";
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
