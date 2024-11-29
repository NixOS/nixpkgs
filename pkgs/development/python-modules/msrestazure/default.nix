{
  lib,
  adal,
  buildPythonPackage,
  fetchFromGitHub,
  httpretty,
  mock,
  msrest,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "msrestazure";
  version = "0.6.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "msrestazure-for-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZZVZi0v1ucD2g5FpLaNhfNBf6Ab10fUEcEdkY4ELaEY=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    adal
    msrest
  ];

  nativeCheckInputs = [
    httpretty
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "msrest" ];

  meta = with lib; {
    description = "Runtime library 'msrestazure' for AutoRest generated Python clients";
    homepage = "https://azure.microsoft.com/en-us/develop/python/";
    license = licenses.mit;
    maintainers = with maintainers; [
      bendlas
    ];
  };
}
