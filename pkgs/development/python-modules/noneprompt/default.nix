{
  buildPythonPackage,
  fetchPypi,
  lib,
  poetry-core,
  prompt-toolkit,
}:

buildPythonPackage rec {
  pname = "noneprompt";
  version = "0.1.11";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aCJpGPKhVDqjgMqtpcOArlyjj1cpInjFv9O3KJ8axts=";
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
