{ lib
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "trak";
  version = "0.0.4";
  pyproject = true;

  src =
    let
      repo = fetchFromGitHub {
        owner = "lcfd";
        repo = "trak";
        rev = "v${version}";
        hash = "sha256-Lc5/i/OuAwHoPo8SeBZe+JSstZov8K/ku7EMyb2I9Ng=";
      };
    in
    "${repo}/cli";

  propagatedBuildInputs = with python3Packages; [
    typer
  ] ++ typer.optional-dependencies.all;

  build-system = [ python3Packages.poetry-core ];

  meta = with lib; {
    description = "Keep a record of the time you dedicate to your projects.";
    homepage = "https://github.com/lcfd/trak";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ buurro ];
    mainProgram = "trak";
  };
}
