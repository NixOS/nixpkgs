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
, openapi-core
, pytest-tornasync
, ruamel-yaml
, strict-rfc3339
}:

buildPythonPackage rec {
  pname = "jupyterlab_server";
  version = "2.7.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "31457ef564febc42043bc539356c804f6f9144f602e2852150bf0820ed6d7e18";
  };

  postPatch = ''
    sed -i "/^addopts/d" pyproject.toml
  '';

  propagatedBuildInputs = [ requests jsonschema pyjson5 Babel jupyter_server ];

  checkInputs = [
    openapi-core
    pytestCheckHook
    pytest-tornasync
    ruamel-yaml
    strict-rfc3339
  ];

  pytestFlagsArray = [ "--pyargs" "jupyterlab_server" ];

  disabledTests = [
    # AttributeError: 'SpecPath' object has no attribute 'paths'
    "test_get_listing"
    "test_get_settings"
    "test_get_federated"
    "test_listing"
    "test_patch"
    "test_patch_unicode"
    "test_get_theme"
    "test_delete"
    "test_get_non_existant"
    "test_get"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "JupyterLab Server";
    homepage = "https://jupyter.org";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
