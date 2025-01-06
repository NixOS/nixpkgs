{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build
  poetry-core,

  # tests
  pytestCheckHook,
  freezegun,
}:

buildPythonPackage rec {
  pname = "astral";
  version = "3.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-m3w7QS6eadFyz7JL4Oat3MnxvQGijbi+vmbXXMxTPYg=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/sffjunkie/astral/releases/tag/${version}";
    description = "Calculations for the position of the sun and the moon";
    homepage = "https://github.com/sffjunkie/astral/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ flokli ];
  };
}
