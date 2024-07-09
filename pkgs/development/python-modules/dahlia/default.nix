{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "dahlia";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dahlia-lib";
    repo = "dahlia";
    rev = "refs/tags/${version}";
    hash = "sha256-t8m/7TSzVvETvn3Jar29jCh55Ti+B0NA8Az/8GHwQAg=";
  };

  build-system = [ poetry-core ];
  pythonImportsCheck = [ "dahlia" ];

  meta = with lib; {
    changelog = "https://github.com/dahlia-lib/dahlia/blob/${src.rev}/CHANGELOG.md";
    description = "Simple text formatting package, inspired by the game Minecraft";
    license = licenses.mit;
    homepage = "https://github.com/dahlia-lib/dahlia";
    maintainers = with maintainers; [ sigmanificient ];
    mainProgram = "dahlia";
  };
}
