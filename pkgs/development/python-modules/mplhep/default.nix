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
  version = "0.3.35";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0l89Vh/vmi8kHeNer2ExGE1ehn1Kw3AbEUm8C55a92w=";
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
