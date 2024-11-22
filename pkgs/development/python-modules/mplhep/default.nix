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
  version = "0.3.52";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "mplhep";
    rev = "refs/tags/v${version}";
    hash = "sha256-fcc/DG4irTvAOjCGAW7hW96z0yJNSvcpanfDGN9H9XI=";
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
