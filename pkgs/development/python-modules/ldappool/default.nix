{ lib, buildPythonPackage, fetchPypi
, pbr, ldap, prettytable, fixtures, testresources, testtools }:

buildPythonPackage rec {
  pname = "ldappool";
  version = "2.4.1";

  src = fetchPypi {
    pname = "ldappool";
    inherit version;
    sha256 = "23edef09cba4b1ae764f1ddada828d8e39d72cf32a457e599f5a70064310ea00";
  };

  postPatch = ''
    # Tests run without most of the dependencies
    echo "" > test-requirements.txt
    # PrettyTable is now maintained again
    substituteInPlace requirements.txt --replace "PrettyTable<0.8,>=0.7.2" "PrettyTable"
  '';

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [ ldap prettytable ];

  checkInputs = [ fixtures testresources testtools ];

  meta = with lib; {
    description = "A simple connector pool for python-ldap";
    homepage = "https://opendev.org/openstack/ldappool/";
    license = with licenses; [ mpl11 lgpl21Plus gpl2Plus ];
  };
}
