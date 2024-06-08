{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  testers,
  dahlia
}:

buildPythonPackage rec {
  pname = "dahlia";
  version = "2.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dahlia-lib";
    repo = "dahlia";
    rev = "refs/tags/${version}";
    hash = "sha256-KQOfTTYA/Jt0UbZ1VKqETwYHtMlOuS2lY0755gqFgxg=";
  };

  build-system = [ poetry-core ];
  pythonImportsCheck = [ "dahlia" ];

  passthru.tests.version = testers.testVersion {
    package = dahlia;
    command = "${lib.getExe dahlia} --version";
    version = "${version}";
  };

  meta = with lib; {
    changelog = "https://github.com/dahlia-lib/dahlia/blob/${src.rev}/CHANGELOG.md";
    description = "A simple text formatting package, inspired by the game Minecraft";
    license = licenses.mit;
    homepage = "https://github.com/dahlia-lib/dahlia";
    maintainers = with maintainers; [ sigmanificient ];
    mainProgram = "dahlia";
  };
}
