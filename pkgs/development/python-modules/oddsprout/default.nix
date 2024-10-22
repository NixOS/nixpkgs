{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  dahlia,
  ixia
}:

buildPythonPackage rec {
  pname = "oddsprout";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trag1c";
    repo = "oddsprout";
    rev = "refs/tags/v${version}";
    hash = "sha256-k5/mBoW4PxGUbkwaZyHgS3MGI4533V/nNoGqEg+VXpM=";
  };

  build-system = [ poetry-core ];
  dependencies = [ dahlia ixia ];

  pythonImportsCheck = [ "oddsprout" ];

  meta = with lib; {
    changelog = "https://github.com/trag1c/oddsprout/blob/${src.rev}/CHANGELOG.md";
    description = "Generate random JSON with no schemas involved";
    license = licenses.mit;
    homepage = "https://trag1c.github.io/oddsprout";
    maintainers = with maintainers; [ sigmanificient ];
  };
}
