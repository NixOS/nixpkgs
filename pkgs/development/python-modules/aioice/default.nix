{
  lib,
  buildPythonPackage,
  setuptools,
  dnspython,
  ifaddr,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aioice";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aiortc";
    repo = "aioice";
    tag = version;
    hash = "sha256-9igQu2ayGE8HcE+ojs9NduMZoblFKmzSlJe72nsm/NA=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    dnspython
    ifaddr
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  disabledTestPaths = [
    # Network tests failing
    "tests/test_ice.py"
    "tests/test_mdns.py"
    "tests/test_turn.py"
    "tests/test_ice_trickle.py"
  ];
  doCheck = true;
  pythonImportsCheck = [
    "aioice"
  ];

  meta = {
    description = "Asyncio-based Interactive Connectivity Establishment (RFC 5245)";
    homepage = "https://github.com/aiortc/aioice";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ gesperon ];
  };
}
