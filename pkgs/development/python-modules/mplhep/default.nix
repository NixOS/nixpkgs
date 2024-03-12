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
  version = "0.3.41";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1L9e2A2u+4+QEWJW2ikuENLD0x5Khjfr7I6p+Vt4nwE=";
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
