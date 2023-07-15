{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "rangehttpserver";
  version = "1.3.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "danvk";
    repo = "RangeHTTPServer";
    rev = "refs/tags/${version}";
    hash = "sha256-ZXEbis37QO8t05JQ2qQQf5rkUSxq3DwzR3khAJkZ5W0=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [
    "RangeHTTPServer"
  ];

  meta = with lib; {
    description = "SimpleHTTPServer with support for Range requests";
    homepage = "https://github.com/danvk/RangeHTTPServer";
    changelog = "https://github.com/danvk/RangeHTTPServer/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
