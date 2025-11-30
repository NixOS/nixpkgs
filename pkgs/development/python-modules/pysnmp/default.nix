{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  pyasn1,
  pysmi,
  pysnmpcrypto,

  # tests
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "pysnmp";
  version = "7.1.22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lextudio";
    repo = "pysnmp";
    tag = "v${version}";
    hash = "sha256-uEOhOVXaz4g1Ciun8x2AT8pRBkKR6uEfu4KJ1XSwouY=";
  };

  build-system = [ flit-core ];

  dependencies = [
    pyasn1
    pysmi
    pysnmpcrypto
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
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
    "test_syntax_integer"
    "test_syntax_unsigned"
    "test_add_asn1_mib_source"
    "test_syntax_fixed_length_octet_string"
  ];

  disabledTestPaths = [
    # MIB file "CISCO-ENHANCED-IPSEC-FLOW-MIB.py[co]" not found in search path
    "tests/smi/manager/test_mib-tree-inspection.py"
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
