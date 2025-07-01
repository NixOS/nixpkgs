{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  gfortran,
  makeWrapper,
  setuptools,
  setuptools-scm,
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
  version = "3.1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "i-pi";
    repo = "i-pi";
    tag = "v${version}";
    hash = "sha256-az1rQlXwYUyPA4wP5wxBZtmJhQlvHxhRZF2O141i76o=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

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
  disabledTests = [
    "test_driver_base"
    "test_driver_forcebuild"
  ];

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
    homepage = "https://ipi-code.org/";
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
