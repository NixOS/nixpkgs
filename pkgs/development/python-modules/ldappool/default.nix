{ lib, buildPythonPackage, fetchPypi
, pbr, ldap, prettytable, fixtures, testresources, testtools }:

buildPythonPackage rec {
  name = "ldappool-${version}";
  version = "2.4.0";

  src = fetchPypi {
    pname = "ldappool";
    inherit version;
    sha256 = "d9c9ec29be3f3e64164be84fe080a3087108836f307a12ec62f7d18988293df3";
  };

  postPatch = ''
    # Tests run without most of the dependencies
    echo "" > test-requirements.txt
  '';

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [ ldap prettytable ];

  checkInputs = [ fixtures testresources testtools ];

  meta = with lib; {
    description = "A simple connector pool for python-ldap";
    homepage = https://git.openstack.org/cgit/openstack/ldappool;
    license = licenses.mpl20;
  };
}
