{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  numpy,
  setuptools,

  # dependencies
  click,
  h5py,
  pandas,
  scipy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "biom-format";
  version = "2.1.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "biocore";
    repo = "biom-format";
    tag = finalAttrs.version;
    hash = "sha256-FjIC21LoqltixBstbbANByjTNxVm/3YCxdWaD9KbOQ0=";
  };

  # https://numpy.org/doc/stable//release/2.4.0-notes.html#removed-numpy-in1d
  postPatch = ''
    substituteInPlace biom/table.py \
      --replace-fail "np.in1d" "np.isin"
  '';

  build-system = [
    cython
    numpy
    setuptools
  ];

  dependencies = [
    click
    h5py
    numpy
    pandas
    scipy
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
    description = "Biological Observation Matrix (BIOM) format";
    homepage = "http://biom-format.org/";
    downloadPage = "https://github.com/biocore/biom-format";
    changelog = "https://github.com/biocore/biom-format/blob/${finalAttrs.src.tag}/ChangeLog.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
})
