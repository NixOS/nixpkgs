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
  version = "7.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lextudio";
    repo = "pysnmp";
    rev = "refs/tags/v${version}";
    hash = "sha256-6KrJfYorC0NDIeoYbtaf5NK+v1YaCdckB1Jjm8BKPdQ=";
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
    #  pysnmp.error.PySnmpError: Bad IPv4/UDP transport address demo.pysnmp.com@161: [Errno -3] Temporary failure in name resolution
    "test_v2c_bulk"
    "test_v2c_get_table_bulk"
    "test_v2c_get_table_bulk_0_7"
    "test_v2c_get_table_bulk_0_8"
    "test_v2c_get_table_bulk_0_31"
    "test_v2c_get_table_bulk_0_60"
    "test_v2c_get_table_bulk_0_5_subtree"
    "test_v2c_get_table_bulk_0_6_subtree"
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
    changelog = "https://github.com/lextudio/pysnmp/blob/${src.rev}/CHANGES.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ hexa ];
  };
}
