{
  lib,
  buildPythonPackage,
  fetchPypi,
  jsonable,
  nose,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mwtypes";
  version = "0.3.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3BF2xZZWKcEj6FmzGa5hUdTjhVMemngWBMDUyjQ045k=";
  };

  propagatedBuildInputs = [ jsonable ];

  nativeCheckInputs = [
    nose
    pytestCheckHook
  ];

  disabledTests = [
    "test_normalize_path_bad_extension"
    "test_open_file"
  ];

  pythonImportsCheck = [ "mwtypes" ];

  meta = with lib; {
    description = "Set of classes for working with MediaWiki data types";
    homepage = "https://github.com/mediawiki-utilities/python-mwtypes";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
