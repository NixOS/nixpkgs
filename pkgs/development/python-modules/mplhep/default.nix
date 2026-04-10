{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  matplotlib,
  mplhep-data,
  numpy,
  uhi,

  # tests
  hist,
  pytest-benchmark,
  pytest-mock,
  pytest-mpl,
  pytestCheckHook,
  scipy,
  uproot,
}:

buildPythonPackage (finalAttrs: {
  pname = "mplhep";
  version = "1.3.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "mplhep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EiLhxkuHDxslz2HH/WIc20eYCJECXV414qnJdsUSVQY=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    matplotlib
    mplhep-data
    numpy
    uhi
  ];

  nativeCheckInputs = [
    hist
    pytest-benchmark
    pytest-mock
    pytest-mpl
    pytestCheckHook
    scipy
    uproot
  ];

  disabledTestPaths = [
    # requires uproot4
    "tests/test_inputs.py"
  ];

  pythonImportsCheck = [ "mplhep" ];

  meta = {
    description = "Extended histogram plots on top of matplotlib and HEP compatible styling similar to current collaboration requirements (ROOT)";
    homepage = "https://github.com/scikit-hep/mplhep";
    changelog = "https://github.com/scikit-hep/mplhep/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
