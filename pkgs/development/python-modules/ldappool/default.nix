{ lib, buildPythonPackage, fetchPypi
, pbr, ldap, fixtures, testresources, testtools }:

buildPythonPackage rec {
  name = "ldappool-${version}";
  version = "2.3.1";

  src = fetchPypi {
    pname = "ldappool";
    inherit version;
    sha256 = "3ef502e65b396a917dbee9035db5d5a5aae6a94897dac2bc253c8257ca1c31a6";
  };

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [ ldap ];

  checkInputs = [ fixtures testresources testtools ];

  meta = with lib; {
    description = "A simple connector pool for python-ldap";
    homepage = https://git.openstack.org/cgit/openstack/ldappool;
    license = licenses.mpl20;
  };
}
