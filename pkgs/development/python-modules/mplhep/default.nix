{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  matplotlib,
  mplhep-data,
  numpy,
  packaging,
  uhi,
  pytestCheckHook,
  scipy,
  pytest-mpl,
  pytest-mock,
  uproot,
  hist,
}:

buildPythonPackage rec {
  pname = "mplhep";
  version = "0.3.51";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "mplhep";
    rev = "refs/tags/v${version}";
    hash = "sha256-5uXqBifJNWznXX4l5G79DLvD6VdD8xRBwZJbzp1+HP8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    matplotlib
    mplhep-data
    numpy
    packaging
    uhi
  ];

  nativeCheckInputs = [
    pytestCheckHook
    scipy
    pytest-mpl
    pytest-mock
    uproot
    hist
  ];

  disabledTests = [
    # requires uproot4
    "test_inputs_uproot"
    "test_uproot_versions"
  ];

  pythonImportsCheck = [ "mplhep" ];

  meta = {
    description = "Extended histogram plots on top of matplotlib and HEP compatible styling similar to current collaboration requirements (ROOT)";
    homepage = "https://github.com/scikit-hep/mplhep";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
