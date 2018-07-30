{ lib, buildPythonPackage, fetchPypi
, pbr, ldap, fixtures, testresources, testtools }:

buildPythonPackage rec {
  name = "ldappool-${version}";
  version = "2.3.0";

  src = fetchPypi {
    pname = "ldappool";
    inherit version;
    sha256 = "899d38e891372981166350c813ff5ce2ad8ac383311edccda8102362c1d60952";
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
