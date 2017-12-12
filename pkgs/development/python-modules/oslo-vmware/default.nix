{ stdenv, buildPythonPackage, fetchPypi
, python, pkgs
, pbr, six
, iso8601, netaddr
, oslo-i18n, oslo-utils
, stevedore
, Babel
, coverage
, testtools
, oslosphinx
, mock
, iana-etc, libredirect
, pyyaml, eventlet, requests, urllib3,oslo-concurrency, suds-jurko
, bandit, testscenarios, testrepository, ddt
}:

buildPythonPackage rec {
  pname = "oslo.vmware";
  version = "2.25.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01i3nsr722r9yczjjsa2xqqzx42jlpldznk111dkc0lihz269x14";
  };

  propagatedBuildInputs = [
    pbr stevedore netaddr iso8601 six oslo-i18n oslo-utils Babel pyyaml eventlet
    requests urllib3 oslo-concurrency suds-jurko
  ];

  checkInputs = [ bandit oslosphinx coverage testtools testscenarios testrepository mock ddt ];

  # 1. ImportError: cannot import name greenthread
  # 2. socket.getprotobyname('tcp')
  preCheck = ''
    rm oslo_vmware/tests/test_image_transfer.py \
       oslo_vmware/tests/test_api.py
  '';

  postPatch = ''

    sed -i 's@python@${python.interpreter}@' .testr.conf
    '';

  meta = with stdenv.lib; {
    description = "provides for a shared location for code common to the VMware drivers in several projects";
    homepage = "http://wiki.openstack.org/wiki/Oslo#oslo.vwmare";
    license = licenses.asl20;
    maintainers = with maintainers; [ makefu ];
  };

}
