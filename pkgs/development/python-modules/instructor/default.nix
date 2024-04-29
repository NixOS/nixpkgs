{ lib
, python3
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "instructor";
  version = "0.6.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4mHXPes1NdYu53XEN7gq626cKy9ju1M7U6n6akfbuVo=";
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
