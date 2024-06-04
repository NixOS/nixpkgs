{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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
  version = "2.1.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "biocore";
    repo = "biom-format";
    rev = "refs/tags/${version}";
    hash = "sha256-WRBc+C/UWme7wYogy4gH4KTIdIqU3KmBm2jWzGNxGQg=";
  };

  patches = [
    # fixes a test, can be removed in next version after 2.1.15
    (fetchpatch {
      name = "fix-dataframe-comparison.patch";
      url = "https://github.com/biocore/biom-format/commit/5d1c921ca2cde5d7332508503ce990a7209d1fdc.patch";
      hash = "sha256-nyHi469ivjJSQ01yIk/6ZMXFdoo9wVuazJHnFdy2nBg=";
    })
  ];

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
