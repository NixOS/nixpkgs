{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build
  poetry-core,

  # tests
  pytestCheckHook,
  freezegun,
}:

buildPythonPackage rec {
  pname = "astral";
  version = "3.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-m3w7QS6eadFyz7JL4Oat3MnxvQGijbi+vmbXXMxTPYg=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [ "astral" ];

  meta = {
    description = "Calculations for the position of the sun and the moon";
    homepage = "https://github.com/sffjunkie/astral/";
    changelog = "https://github.com/sffjunkie/astral/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ flokli ];
  };
}
