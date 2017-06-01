{ buildPythonPackage, fetchurl, isPy3k, requests, novaclient, six, lib }:
let
os-virtual-interfacesv2-python-novaclient-ext = buildPythonPackage rec {
  name = "os_virtual_interfacesv2_python_novaclient_ext-0.20";

  src = fetchurl {
    url = "mirror://pypi/o/os-virtual-interfacesv2-python-novaclient-ext/${name}.tar.gz";
    sha256 = "17a4r8psxmfikgmzh709absbn5jsh1005whibmwhysj9fi0zyfbd";
  };

  propagatedBuildInputs = [ six novaclient ];

  meta = {
    homepage = https://github.com/rackerlabs/os_virtual_interfacesv2_ext;
    license = lib.licenses.asl20;
    description = "Adds Virtual Interfaces support to python-novaclient";
  };
};

ip-associations-python-novaclient-ext = buildPythonPackage rec {
  name = "ip_associations_python_novaclient_ext-0.2";

  src = fetchurl {
    url = "mirror://pypi/i/ip_associations_python_novaclient_ext/${name}.tar.gz";
    sha256 = "0dxfkfjhzskafmb01y8hzbcpvc4cd6fas1s50dzcmg29w4z6qmz4";
  };

  propagatedBuildInputs = [ six novaclient ];

  meta = {
    homepage = https://github.com/rackerlabs/ip_associations_python_novaclient_ext;
    license = lib.licenses.asl20;
    description = "Adds Rackspace ip_associations support to python-novaclient";
  };
};


rackspace-auth-openstack = buildPythonPackage rec {
  name = "rackspace-auth-openstack-1.3";

  src = fetchurl {
    url = "mirror://pypi/r/rackspace-auth-openstack/${name}.tar.gz";
    sha256 = "1kaiyvgwmavw2mh0s32yjk70xsziynjdhi01qn9a8kljn7p6kh64";
  };

  propagatedBuildInputs = [ six novaclient ];

  meta = {
    homepage = https://pypi.python.org/pypi/rackspace-auth-openstack;
    license = lib.licenses.asl20;
    description = "Rackspace Auth Plugin for OpenStack Clients.";
  };
};
rax-default-network-flags-python-novaclient-ext = buildPythonPackage rec {
  name = "rax_default_network_flags_python_novaclient_ext-0.4.0";

  src = fetchurl {
    url = "mirror://pypi/r/rax_default_network_flags_python_novaclient_ext/${name}.tar.gz";
    sha256 = "00b0csb58k6rr1is68bkkw358mms8mmb898bm8bbr8g7j2fz8aw5";
  };

  propagatedBuildInputs = [ six novaclient ];

  meta = {
    homepage = https://pypi.python.org/simple/rax-default-network-flags-python-novaclient-ext;
    license = lib.licenses.asl20;
    description = "Novaclient Extension for Instance Default Network Flags";
  };
};
os-networksv2-python-novaclient-ext = buildPythonPackage rec {
  name = "os_networksv2_python_novaclient_ext-0.26";

  src = fetchurl {
    url = "mirror://pypi/o/os_networksv2_python_novaclient_ext/${name}.tar.gz";
    sha256 = "06dzqmyrwlq7hla6dk699z18c8v27qr1gxqknimwxlwqdlhpafk1";
  };

  propagatedBuildInputs = [ six novaclient ];

  meta = {
    homepage = https://pypi.python.org/pypi/os_networksv2_python_novaclient_ext;
    license = lib.licenses.asl20;
    description = "Adds rackspace networks support to python-novaclient";
  };
};

rax-scheduled-images-python-novaclient-ext = buildPythonPackage rec {
  name = "rax_scheduled_images_python_novaclient_ext-0.3.1";

  src = fetchurl {
    url = "mirror://pypi/r/rax_scheduled_images_python_novaclient_ext/${name}.tar.gz";
    sha256 = "1nvwjgrkp1p1d27an393qf49pszm1nvqa2ychhbqmp0bnabwyw7i";
  };

  propagatedBuildInputs = [ six novaclient ];

  meta = {
    homepage = https://pypi.python.org/pypi/rax_scheduled_images_python_novaclient_ext;
    license = lib.licenses.asl20;
    description = "Extends python-novaclient to use RAX-SI, the Rackspace Nova API Scheduled Images extension";
  };
};

os-diskconfig-python-novaclient-ext = buildPythonPackage rec {
  name = "os_diskconfig_python_novaclient_ext-0.1.3";

  src = fetchurl {
    url = "mirror://pypi/o/os_diskconfig_python_novaclient_ext/${name}.tar.gz";
    sha256 = "0xayy5nlkgl9yr0inqkwirlmar8pv1id29r59lj70g5plwrr5lg7";
  };

  propagatedBuildInputs = [ six novaclient ];

  meta = {
    homepage = https://pypi.python.org/pypi/os_diskconfig_python_novaclient_ext;
    license = lib.licenses.asl20;
    description = "Disk Config extension for python-novaclient";
  };
};

in
buildPythonPackage rec {
  name = "rackspace-novaclient-2.1";

  src = fetchurl {
    url = "mirror://pypi/r/rackspace-novaclient/${name}.tar.gz";
    sha256 = "1rzaa328hzm8hs9q99gvjr64x47fmcq4dv4656rzxq5s4gv49z12";
  };

  disabled = isPy3k;
  propagatedBuildInputs = [
    requests
    novaclient
    six
    # extensions
    ip-associations-python-novaclient-ext
    os-diskconfig-python-novaclient-ext
    os-networksv2-python-novaclient-ext
    os-virtual-interfacesv2-python-novaclient-ext
    rackspace-auth-openstack
    rax-default-network-flags-python-novaclient-ext
    rax-scheduled-images-python-novaclient-ext
  ];

  meta = {
    homepage = https://pypi.python.org/pypi/rackspace-novaclient/;
    license = lib.licenses.asl20;
    description = "Metapackage to install python-novaclient and Rackspace extensions";
    maintainers = with lib.maintainers; [ teh ];
  };
}
