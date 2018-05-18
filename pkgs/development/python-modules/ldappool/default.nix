{ lib, buildPythonPackage, fetchPypi, isPy3k
, pbr, ldap, fixtures, testresources, testtools }:

buildPythonPackage rec {
  name = "ldappool-${version}";
  version = "2.2.0";

  src = fetchPypi {
    pname = "ldappool";
    inherit version;
    sha256 = "1akmzf51cjfvmd0nvvm562z1w9vq45zsx6fa72kraqgsgxhnrhqz";
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
