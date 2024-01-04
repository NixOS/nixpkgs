{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonPackage rec {
  pname = "pre-commit-poetry-export";
  version = "0.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gA1X31/5bG3P8cr2+PiLsIvQT1AXoSXpTOngXqJ+YLg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace poetry.masonry.api poetry.core.masonry.api \
      --replace "poetry>=0.12" "poetry-core>=0.12"
  '';


  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  pythonImportsCheck = [ "pre_commit_poetry_export" ];

  meta = with lib; {
    description = "Pre-commit hook to keep requirements.txt updated";
    homepage = "https://pypi.org/project/pre-commit-poetry-export/";
    license = licenses.mit;
    maintainers = with maintainers; [ TheBrainScrambler ];
  };
}
