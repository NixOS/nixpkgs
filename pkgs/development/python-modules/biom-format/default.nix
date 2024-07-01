{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
  click,
  numpy,
  scipy,
  pandas,
  h5py,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "biom-format";
  version = "2.1.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "biocore";
    repo = "biom-format";
    rev = "refs/tags/${version}";
    hash = "sha256-E/6dIN8tdsu6cBVBW/BOeAQwJB9XRRL3flQZSKqIZlc=";
  };

  build-system = [
    setuptools
    cython
    numpy
  ];

  dependencies = [
    click
    numpy
    scipy
    pandas
    h5py
  ];

  # make pytest resolve the package from $out
  # some tests don't work if we change the level of directory nesting
  preCheck = ''
    mkdir biom_tests
    mv biom/tests biom_tests/tests
    rm -r biom
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "biom_tests/tests" ];

  pythonImportsCheck = [ "biom" ];

  meta = {
    homepage = "http://biom-format.org/";
    description = "Biological Observation Matrix (BIOM) format";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
