{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpretty,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-oauthlib,
}:

buildPythonPackage rec {
  pname = "pymfy";
  version = "0.11.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tetienne";
    repo = "somfy-open-api";
    rev = "v${version}";
    sha256 = "0wpjwjmywfyqgwvfa5kwcjpaljc32qa088kk88nl9nqdvc31mzhv";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    requests
    requests-oauthlib
  ];

  nativeCheckInputs = [
    httpretty
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pymfy" ];

  meta = with lib; {
    description = "Python client for the Somfy Open API";
    homepage = "https://github.com/tetienne/somfy-open-api";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
