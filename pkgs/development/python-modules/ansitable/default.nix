{
  lib,
  buildPythonPackage,
  colored,
  fetchPypi,
  hatchling,
  numpy,
  pandas,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ansitable";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-baf/GemGygLLZK3f2Nv7qLYQVP/44O/kWLeP0KLZyhs=";
  };

  build-system = [ hatchling ];

  dependencies = [ colored ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
    pandas
  ];

  pythonImportsCheck = [ "ansitable" ];

  meta = {
    description = "Quick and easy display of tabular data and matrices with optional ANSI color and borders";
    homepage = "https://github.com/petercorke/ansitable";
    changelog = "";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      djacu
      a-camarillo
    ];
  };
}
