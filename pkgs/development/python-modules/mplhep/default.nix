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
  packaging,
  uhi,

  # tests
  hist,
  pytest-mock,
  pytest-mpl,
  pytestCheckHook,
  scipy,
  uproot,
}:

buildPythonPackage rec {
  pname = "mplhep";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "mplhep";
    tag = "v${version}";
    hash = "sha256-Sx/VR573Vhxfv043mVdMpu/v6Ukv/JrVXBlpbILqGsI=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    matplotlib
    mplhep-data
    numpy
    packaging
    uhi
  ];

  nativeCheckInputs = [
    hist
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
    changelog = "https://github.com/scikit-hep/mplhep/releases/tag/${src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
