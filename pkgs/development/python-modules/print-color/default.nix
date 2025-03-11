{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "print-color";
  version = "0.4.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "xy3";
    repo = "print-color";
    tag = "v${version}";
    hash = "sha256-PHPbzzWG7smEsoTFYFT2tgXfCxUYjevpB9rxG2bZVy4=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "print_color" ];

  meta = with lib; {
    description = "Module to print color messages in the terminal";
    homepage = "https://github.com/xy3/print-color";
    changelog = "https://github.com/xy3/print-color/releases/tag/v${version}";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ fab ];
  };
}
