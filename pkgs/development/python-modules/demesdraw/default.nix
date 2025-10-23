{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  demes,
  matplotlib,
  numpy,
  scipy,
  pythonOlder,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-xdist,
  mpmath,
}:

buildPythonPackage rec {
  pname = "demesdraw";
  version = "0.4.1";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sPxdSXWRh6qnUKmP9g/AghOX5Ydrxv2Le2iadefQDws=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    demes
    matplotlib
    numpy
    scipy
  ];

  # This variable is needed to suppress the "Trace/BPT trap: 5" error in Darwin's checkPhase.
  # Not sure of the details, but we can avoid it by changing the matplotlib backend during testing.
  env.MPLBACKEND = lib.optionalString stdenv.hostPlatform.isDarwin "Agg";

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-xdist
    mpmath
  ];

  pythonImportsCheck = [ "demesdraw" ];

  meta = with lib; {
    description = "Drawing functions for Demes demographic models";
    mainProgram = "demesdraw";
    homepage = "https://github.com/grahamgower/demesdraw";
    license = licenses.isc;
    maintainers = [ ];
  };
}
