{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  fastcore,
  sqlite-minutils,
}:

buildPythonPackage rec {
  pname = "fastlite";
  version = "0.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AnswerDotAI";
    repo = "fastlite";
    rev = "refs/tags/${version}";
    hash = "sha256-g8A265F3aGKtc6iiWtQ7Y2192w5JXf5YG3jH3BYlMUI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    fastcore
    sqlite-minutils
  ];

  pythonImportsCheck = [ "fastlite" ];

  doCheck = false; # no tests

  meta = {
    description = "Bit of extra usability for sqlite";
    homepage = "https://github.com/AnswerDotAI/fastlite";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
