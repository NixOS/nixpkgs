{
  lib,
  buildPythonPackage,
  fetchPypi,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "nameparser";
  version = "1.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pbkQXee4eZCWVraVTnBm8GvHp0Om5ncbGUZbC7vmpM8=";
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
