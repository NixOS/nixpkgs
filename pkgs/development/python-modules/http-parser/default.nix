{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  setuptools,
  pytestCheckHook,
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

  pythonImportsCheck = [ "http_parser" ];

  # The imp module is deprecated since version 3.4, and was removed in 3.12
  # https://docs.python.org/3.11/library/imp.html
  # Fix from: https://github.com/benoitc/http-parser/pull/101/
  patches = [ ./imp-importlib.diff ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "HTTP request/response parser for python in C";
    homepage = "https://github.com/benoitc/http-parser";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
