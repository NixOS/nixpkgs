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
  version = "2.1.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "biocore";
    repo = "biom-format";
    tag = version;
    hash = "sha256-FjIC21LoqltixBstbbANByjTNxVm/3YCxdWaD9KbOQ0=";
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

  enabledTestPaths = [ "biom_tests/tests" ];

  pythonImportsCheck = [ "biom" ];

  meta = {
    homepage = "http://biom-format.org/";
    description = "Biological Observation Matrix (BIOM) format";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
