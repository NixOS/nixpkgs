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
<<<<<<< HEAD
  version = "0.10.2";
=======
  version = "0.10.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aiortc";
    repo = "aioice";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-UEXkTxcpe6mlA2FmMSfDmtcEYE9zwuitpi2Eh188xZc=";
=======
    hash = "sha256-KFYPzGPm+d1QrFAW9OhTDxroV/MnFusmfy5qcYCfDiM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
