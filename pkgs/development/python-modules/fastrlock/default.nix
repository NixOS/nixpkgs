{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fastrlock";
  version = "0.8.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "scoder";
    repo = "fastrlock";
    tag = "v${version}";
    hash = "sha256-yUPptWzmJ6vr4vMR6AQUQGAxymF4e9Otu3wr6NsCbmg=";
  };

  nativeBuildInputs = [ cython ];

  # Todo: Check why the tests have an import error
  doCheck = false;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fastrlock" ];

  meta = {
    description = "RLock implementation for CPython";
    homepage = "https://github.com/scoder/fastrlock";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
