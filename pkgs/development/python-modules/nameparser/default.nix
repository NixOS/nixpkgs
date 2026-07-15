{
  lib,
  buildPythonPackage,
  fetchPypi,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "nameparser";
  version = "1.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qiQArXHM+AcGdbQDEaJXyTRln5GFSxVOG6bCZHYcBJ0=";
  };

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "nameparser" ];

  meta = {
    description = "Module for parsing human names into their individual components";
    homepage = "https://github.com/derek73/python-nameparser";
    changelog = "https://github.com/derek73/python-nameparser/releases/tag/v${version}";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
  };
}
