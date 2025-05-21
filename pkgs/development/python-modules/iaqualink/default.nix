{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  httpx,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  respx,
}:

buildPythonPackage rec {
  pname = "iaqualink";
  version = "0.5.3";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "flz";
    repo = "iaqualink-py";
    tag = "v${version}";
    hash = "sha256-2DqZJlsbDWo9fxIDg5P0CvZs8AuAh8XrhNiwIvuRm80=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [ httpx ] ++ httpx.optional-dependencies.http2;

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [ "iaqualink" ];

  meta = with lib; {
    description = "Python library for Jandy iAqualink";
    homepage = "https://github.com/flz/iaqualink-py";
    changelog = "https://github.com/flz/iaqualink-py/releases/tag/v${src.tag}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
