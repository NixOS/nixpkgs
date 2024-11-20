{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  langchain,
}:

buildPythonPackage rec {
  pname = "permchain";
  version = "0.0.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vp9tTa1v1oUP3E1xGM/KD2BpkoNgN2xRkb3Lei0ehMI=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    langchain
  ];

  pythonImportsCheck = [
    "permchain"
  ];

  meta = {
    description = "Permchain";
    homepage = "https://pypi.org/project/permchain";
    license = with lib.licenses; [
      elastic20
      mit
    ];
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
