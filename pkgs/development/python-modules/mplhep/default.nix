{ lib
, buildPythonPackage
, fetchPypi
, hist
, matplotlib
, mplhep-data
, pytestCheckHook
, pytest-mock
, pytest-mpl
, scipy
, setuptools
, setuptools-scm
, uhi
, uproot
}:

buildPythonPackage rec {
  pname = "mplhep";
  version = "0.3.28";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/7nfjIdlYoouDOI1vXdr9BSml5gpE0gad7ONAUmOCiE=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    matplotlib
    uhi
    mplhep-data
  ];

  nativeCheckInputs = [
    hist
    pytestCheckHook
    pytest-mock
    pytest-mpl
    scipy
    uproot
  ];

  disabledTests = [
    # requires uproot4
    "test_inputs_uproot"
    "test_uproot_versions"
  ];

  pythonImportsCheck = [
    "mplhep"
  ];

  meta = with lib; {
    description = "Extended histogram plots on top of matplotlib and HEP compatible styling similar to current collaboration requirements (ROOT)";
    homepage = "https://github.com/scikit-hep/mplhep";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ veprbl ];
  };
}
