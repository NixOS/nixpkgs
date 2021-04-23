{ lib
, buildPythonPackage
, fetchPypi
, jsonschema
, pythonOlder
, requests
, pytestCheckHook
, pyjson5
, Babel
, jupyter_server
, pytest-tornasync
, pytestcov
, strict-rfc3339
}:

buildPythonPackage rec {
  pname = "jupyterlab_server";
  version = "2.3.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-56AkWqPeI6GAPeLv9AHkykWUU42fWYBhNPMEGabYtqM=";
  };

  propagatedBuildInputs = [ requests jsonschema pyjson5 Babel jupyter_server ];

  checkInputs = [
    pytestCheckHook
    pytest-tornasync
    pytestcov
    strict-rfc3339
  ];

  disabledTests = [
    "test_get_locale"
    "test_get_installed_language_pack_locales_passes"
    "test_get_installed_package_locales"
    "test_get_installed_packages_locale"
    "test_get_language_packs"
    "test_get_language_pack"
  ];

  meta = with lib; {
    description = "JupyterLab Server";
    homepage = "https://jupyter.org";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
