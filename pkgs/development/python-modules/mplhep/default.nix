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
  version = "0.3.55";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "mplhep";
    tag = "v${version}";
    hash = "sha256-7YkrrH9Bfn3ctjv+H6TXEDE8yS/wnjO7umuHIXeYTDU=";
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
