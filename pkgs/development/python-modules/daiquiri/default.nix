{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  python-json-logger,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "daiquiri";
  version = "3.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yh0ywsCgbzYU/4A6h6wdUNYo2zTQv37ZffDKV2MyBU8=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [ python-json-logger ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "daiquiri" ];

  meta = with lib; {
    description = "Library to configure Python logging easily";
    homepage = "https://github.com/Mergifyio/daiquiri";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
