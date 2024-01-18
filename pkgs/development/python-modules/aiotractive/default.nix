{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, yarl
}:

buildPythonPackage rec {
  pname = "aiotractive";
  version = "0.5.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zhulik";
    repo = "aiotractive";
    rev = "refs/tags/v${version}";
    hash = "sha256-fIdIFG1OpAN1R2L2RryTzYZyqGLo3tqAAkRC8UUFM4k=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "aiotractive"
  ];

  meta = with lib; {
    changelog = "https://github.com/zhulik/aiotractive/releases/tag/v${version}";
    description = "Python client for the Tractive REST API";
    homepage = "https://github.com/zhulik/aiotractive";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
