{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  click,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "click-didyoumean";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "click-contrib";
    repo = "click-didyoumean";
    tag = "v${version}";
    hash = "sha256-C8OrJUfBFiDM/Jnf1iJo8pGEd0tUhar1vu4fVIfGzq8=";
  };

  build-system = [ poetry-core ];

  dependencies = [ click ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Enable git-like did-you-mean feature in click";
    homepage = "https://github.com/click-contrib/click-didyoumean";
    license = licenses.mit;
    maintainers = with maintainers; [ mbode ];
  };
}
