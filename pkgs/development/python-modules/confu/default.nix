{
  lib,
  python,
  fetchPypi,
}:

python.pkgs.buildPythonPackage rec {
  pname = "confu";
  version = "1.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vJIdLPFOzL/8oTHnUUmF1dMgGHVlr+cxyHo2fSnNK4c=";
  };

  build-system = [
    python.pkgs.poetry-core
  ];

  dependencies = with python.pkgs; [
    munge
  ];

  optional-dependencies = with python.pkgs; {
    docs = [
      markdown-include
      mkdocs
      pymdgen
    ];
  };

  pythonImportsCheck = [
    "confu"
  ];

  meta = {
    description = "Configuration file validation and generation";
    homepage = "https://pypi.org/project/confu/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ xgwq ];
    mainProgram = "confu";
  };
}
