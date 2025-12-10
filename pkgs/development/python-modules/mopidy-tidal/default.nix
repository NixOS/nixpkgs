{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mopidy,
  poetry-core,
  tidalapi,
  pytestCheckHook,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "Mopidy-Tidal";
  version = "0.3.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tehkillerbee";
    repo = "mopidy-tidal";
    tag = "v${version}";
    hash = "sha256-wqx/30UQVm1fEwP/bZeW7TtzGfn/wI0klQnFr9E3AOs=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    mopidy
    tidalapi
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  enabledTestPaths = [ "tests/" ];

  meta = {
    description = "Mopidy extension for playing music from Tidal";
    homepage = "https://github.com/tehkillerbee/mopidy-tidal";
    changelog = "https://github.com/tehkillerbee/mopidy-tidal/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
