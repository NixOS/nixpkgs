{ lib
, python3
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "instructor";
  version = "0.6.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Af52TGnkqY/t0cPkHoRfhFqa/tuOpQXAI/fFfMTcM4Y=";
  };

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    docstring-parser
    openai
    pydantic
    rich
    tenacity
    typer
  ];

  pythonImportsCheck = [ "instructor" ];

  meta = with lib; {
    description = "Structured outputs for llm";
    homepage = "https://github.com/jxnl/instructor";
    changelog = "https://github.com/jxnl/instructor/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    mainProgram = "instructor";
  };
}
