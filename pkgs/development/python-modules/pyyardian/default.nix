{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pythonOlder
, wheel
}:

buildPythonPackage rec {
  pname = "pyyardian";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "h3l1o5";
    repo = "pyyardian";
    rev = "refs/tags/${version}";
    hash = "sha256-JBb62pFDuVcXIGRc6UOp5/ciUtbGm4XnKZjt1icF/jQ=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [
    "pyyardian"
  ];

  meta = with lib; {
    description = "Module for interacting with the Yardian irrigation controller";
    homepage = "https://github.com/h3l1o5/pyyardian";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
