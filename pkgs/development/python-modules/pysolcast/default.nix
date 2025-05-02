{
  lib,
  anyconfig,
  buildPythonPackage,
  fetchFromGitHub,
  isodate,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  requests,
  responses,
  poetry-core,
  pythonRelaxDepsHook,
}:

buildPythonPackage rec {
  pname = "pysolcast";
  version = "2.0.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "mcaulifn";
    repo = "solcast";
    rev = "refs/tags/v${version}";
    hash = "sha256-DXJkbAlkxBjUEbziFNdr8SilB2GRUoAwvrr0HY56Deg=";
  };

  pythonRelaxDeps = [ "responses" ];

  build-system = [ poetry-core ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  dependencies = [
    anyconfig
    isodate
    pyyaml
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "pysolcast" ];

  meta = with lib; {
    description = "Python library for interacting with the Solcast API";
    homepage = "https://github.com/mcaulifn/solcast";
    changelog = "https://github.com/mcaulifn/solcast/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
