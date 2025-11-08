{
  buildPythonPackage,
  fetchPypi,
  lib,
  poetry-core,
  prompt-toolkit,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "noneprompt";
  version = "0.1.9";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-M4uLuJqNIu818d7bOqfBsijPE5lzvcQ8X/w+72RFfbk=";
  };

  build-system = [ poetry-core ];

  dependencies = [ prompt-toolkit ];

  # no test
  doCheck = false;

  pythonImportsCheck = [ "noneprompt" ];

  meta = {
    description = "Prompt toolkit for console interaction";
    homepage = "https://github.com/nonebot/noneprompt";
    changelog = "https://github.com/nonebot/noneprompt/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "noneprompt";
  };
}
