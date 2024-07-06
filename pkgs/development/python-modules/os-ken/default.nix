{ lib
, fetchFromGitHub
, buildPythonPackage
, pbr
, eventlet
, msgpack
, netaddr
, oslo-config
, oslotest
, six
, webob
, routes
, ovs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "os-ken";
  version = "2.3.1";

  # opendev.org mirror
  src = fetchFromGitHub {
    owner = "openstack";
    repo = "os-ken";
    rev = version;
    sha256 = "sha256-nZYo2yrds7U6tEFIkOt2ENjZITBPlOQ214fowVBNSeU=";
  };

  # We are installing from a tarball, so pbr will not be able to derive versioning.
  PBR_VERSION = version;

  propagatedBuildInputs = [
    pbr
    eventlet
    msgpack
    netaddr
    oslo-config
    six
    routes
    webob
    ovs
  ];

  checkInputs = [ pytestCheckHook oslotest ];

  pytestFlagsArray = [
    "--ignore=os_ken/tests/integrated"
    "--ignore=os_ken/tests/mininet"
    "--ignore=os_ken/tests/switch"
  ];
  /*
  =========================== short test summary info ============================
  FAILED os_ken/tests/unit/packet/test_igmp.py::Test_igmpv3_report_group::test_aux_len_larger_than_aux
  FAILED os_ken/tests/unit/packet/test_igmp.py::Test_igmpv3_report_group::test_aux_len_smaller_than_aux
  FAILED os_ken/tests/unit/packet/test_igmp.py::Test_igmpv3_report_group::test_num_larger_than_srcs
  FAILED os_ken/tests/unit/packet/test_igmp.py::Test_igmpv3_report_group::test_num_smaller_than_srcs
  =========== 4 failed, 121132 passed, 1 warning in 408.38s (0:06:48) ============
  */

  disabledTests = [
    "test_aux_len_smaller_than_aux"
    "test_aux_len_larger_than_aux"
    "test_num_smaller_than_srcs"
    "test_num_larger_than_srcs"
  ];

  meta = with lib; {
    description = "Software-defined networking framework for OpenStack Neutron, fork of the Ryu library";
    homepage = "https://github.com/openstack/os-ken";
    license = licenses.asl20;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
