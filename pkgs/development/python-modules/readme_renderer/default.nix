{ lib
, bleach
, buildPythonPackage
, cmarkgfm
, docutils
, fetchPypi
, mock
, pygments
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "readme-renderer";
  version = "35.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "readme_renderer";
    inherit version;
    sha256 = "sha256-pyeZms/CIvwh2CoS7UjJV8SYl4XlhlgHxlpIfSFndJc=";
  };

  propagatedBuildInputs = [
    bleach
    cmarkgfm
    docutils
    pygments
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "cmarkgfm>=0.5.0,<0.7.0" "cmarkgfm>=0.5.0,<1"
  '';

  disabledTests = [
    # https://github.com/pypa/readme_renderer/issues/221
    "test_GFM_"
    # Relies on old distutils behaviour removed by setuptools (TypeError: dist must be a Distribution instance)
    "test_valid_rst"
    "test_invalid_rst"
    "test_malicious_rst"
    "test_invalid_missing"
    "test_invalid_empty"
  ];

  pythonImportsCheck = [
    "readme_renderer"
  ];

  meta = with lib; {
    description = "Python library for rendering readme descriptions";
    homepage = "https://github.com/pypa/readme_renderer";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
