{
  lib,
  nix-update-script,
  fetchPypi,
  buildPythonApplication,
  setuptools,
  click,
  fonttools,
  uharfbuzz,
  pyyaml,
  colorlog,
}:
buildPythonApplication rec {
  pname = "hyperglot";
  version = "0.8.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Y2TPW1NabBbOMcFoaHYksLoFMWT9xHaY+7v/kfUOkmM=";
  };

  dependencies = [
    click
    fonttools
    uharfbuzz
    pyyaml
    colorlog
  ];

  build-system = [ setuptools ];

  pythonImportsCheck = [ "hyperglot" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Database and tools for detecting language support in fonts";
    homepage = "https://hyperglot.rosettatype.com";
    changelog = "https://github.com/rosettatype/hyperglot/blob/${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ imatpot ];
    mainProgram = "hyperglot";
  };
}
