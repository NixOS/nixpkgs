{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  crossandra,
  dahlia,
}:

buildPythonPackage rec {
  pname = "samarium";
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "samarium-lang";
    repo = "samarium";
    rev = "refs/tags/${version}";
    hash = "sha256-sOkJ67B8LaIA2cwCHaFnc16lMG8uaegBJCzF6Li77vk=";
  };

  build-system = [ poetry-core ];
  dependencies = [
    crossandra
    dahlia
  ];

  meta = with lib; {
    changelog = "https://github.com/samarium-lang/samarium/blob/${src.rev}/CHANGELOG.md";
    description = "The Samarium Programming Language";
    license = licenses.mit;
    homepage = "https://samarium-lang.github.io/Samarium";
    maintainers = with maintainers; [ sigmanificient ];
  };
}
