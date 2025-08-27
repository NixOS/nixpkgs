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
  version = "0.6.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "flz";
    repo = "iaqualink-py";
    tag = "v${version}";
    hash = "sha256-s/ZhcbTaCvn7ei1O4+P4fKPojitl+4gsatc9PZx+W2g=";
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
