{
  lib,
  anyconfig,
  buildPythonPackage,
  fetchFromGitHub,
  isodate,
  poetry-core,
  poetry-dynamic-versioning,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  requests,
  responses,
}:

buildPythonPackage rec {
  pname = "pysolcast";
  version = "2.0.6";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "mcaulifn";
    repo = "solcast";
    rev = "refs/tags/v${version}";
    hash = "sha256-x91QVCDPjfC8rCVam/mrc8HP84ONa2/mJtSV64hrilc=";
  };

  pythonRelaxDeps = [ "responses" ];

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];


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
