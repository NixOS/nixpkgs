{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "http-parser";
  version = "0.9.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "benoitc";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-WHimvSaNcncwzLwwk5+ZNg7BbHF+hPr39SfidEDYfhU=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  preBuild = ''
    # re-run cython
    make -B
  '';

  pythonImportsCheck = [
    "http_parser"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "HTTP request/response parser for python in C";
    homepage = "https://github.com/benoitc/http-parser";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
