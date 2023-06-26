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
  version = "40.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "readme_renderer";
    inherit version;
    hash = "sha256-n3e1GdltA9fX3ORJd7pUMJChQ5fE9g3ltutbgEgRCqQ=";
  };

  propagatedBuildInputs = [
    bleach
    cmarkgfm
    docutils
    pygments
  ];

  nativeCheckInputs = [
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
    # https://github.com/pypa/readme_renderer/issues/274
    "test_CommonMark_008.md"
    "test_rst_008.rst"
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
    changelog = "https://github.com/pypa/readme_renderer/blob/${version}/CHANGES.rst";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
