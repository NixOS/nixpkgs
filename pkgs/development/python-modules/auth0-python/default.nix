{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, callee
, fetchPypi
, mock
, poetry-core
, poetry-dynamic-versioning
, pyjwt
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "auth0-python";
  version = "4.4.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "auth0_python";
    inherit version;
    hash = "sha256-4XWxx0GlDVkABwK69laqOFZliWelQ5mWul3FcWnxuko=";
  };

  nativeBuildInputs = [
    poetry-core
    poetry-dynamic-versioning
  ];

  propagatedBuildInputs = [
    requests
    pyjwt
  ] ++ pyjwt.optional-dependencies.crypto;

  nativeCheckInputs = [
    aiohttp
    aioresponses
    callee
    mock
    pytestCheckHook
  ];

  disabledTests = [
    # Tries to ping websites (e.g. google.com)
    "can_timeout"
    "test_options_are_created_by_default"
    "test_options_are_used_and_override"
  ];

  pythonImportsCheck = [
    "auth0"
  ];

  meta = with lib; {
    description = "Auth0 Python SDK";
    homepage = "https://github.com/auth0/auth0-python";
    changelog = "https://github.com/auth0/auth0-python/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
