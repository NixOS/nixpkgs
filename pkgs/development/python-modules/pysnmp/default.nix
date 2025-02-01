{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  pyasn1,
  pysmi,
  pysnmpcrypto,

  # tests
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "pysnmp";
  version = "6.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lextudio";
    repo = "pysnmp";
    rev = "refs/tags/v${version}";
    hash = "sha256-EGMUTUN95wykU756GJSiXwr8Hi3kyaLPfqhuDgvhbBE=";
  };

  pythonRemoveDeps = [ "pytest-cov" ];

  build-system = [ poetry-core ];

  dependencies = [
    pyasn1
    pysmi
    pysnmpcrypto
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = [
    # Temporary failure in name resolution
    "test_custom_asn1_mib_search_path"
    "test_send_notification"
    "test_send_trap"
    "test_send_v3_inform_notification"
    "test_send_v3_inform_sync"
    "test_usm_sha_aes128"
    "test_v1_get"
    "test_v1_next"
    "test_v1_set"
    "test_v2c_bulk"
    # pysnmp.smi.error.MibNotFoundError
    "test_send_v3_trap_notification"
    "test_addAsn1MibSource"
    "test_v1_walk"
    "test_v2_walk"
  ];

  pythonImportsCheck = [ "pysnmp" ];

  meta = with lib; {
    description = "Python SNMP library";
    homepage = "https://github.com/lextudio/pysnmp";
    changelog = "https://github.com/lextudio/pysnmp/blob/${src.rev}/CHANGES.txt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ hexa ];
  };
}
