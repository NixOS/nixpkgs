{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  setuptools,
  pytestCheckHook,
  fetchpatch,
}:

buildPythonPackage rec {
  pname = "http-parser";
  version = "0.9.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "benoitc";
    repo = "http-parser";
    tag = version;
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
  patches = [
    (fetchpatch {
      url = "https://github.com/benoitc/http-parser/commit/4d4984ce129253f9de475bfd3c683301c916e8b1.patch";
      hash = "sha256-d3k1X41/D9PpPWsDety2AiYyLv9LJIhpkOo3a6qKcB8=";
    })
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "HTTP request/response parser for python in C";
    homepage = "https://github.com/benoitc/http-parser";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
