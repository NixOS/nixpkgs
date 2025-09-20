{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
  wheel,

  # dependencies
  comet-maths,
  obsarray,

  # tests
  pytestCheckHook,
  fetchFromGitHub,
  punpy,
}:

buildPythonPackage rec {
  pname = "punpy";
  version = "1.0.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ynn01YcxIkM3tWaOBUZOvVRt3w7iRjPgcO22VakGTNM=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    comet-maths
    obsarray
  ];

  pythonImportsCheck = [
    "punpy"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];
  passthru = {
    # Tests data is not available on Pypi, and unfortunately we don't have a
    # choice but to use Pypi and not GitHub for the src, because upstream
    # donesn't tag properly the GitHub repository.
    testsData = fetchFromGitHub {
      owner = "comet-toolkit";
      repo = "punpy";
      rev = "257f2472c8dd1d3cb58084337824cae6aec1489a";
      hash = "sha256-YW95EyxoTr1Sj8p3UYXTYk/UB1uLuq3A5W65WLE8E7U=";
      sparseCheckout = [
        "punpy/digital_effects_table/tests"
      ];
    };
  };
  preCheck = ''
    for nc in ${punpy.passthru.testsData}/punpy/digital_effects_table/tests/*.nc; do
      cp $nc punpy/digital_effects_table/tests/
    done
  '';

  meta = {
    description = "Propagating UNcertainties in PYthon";
    homepage = "https://punpy.readthedocs.io/";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
