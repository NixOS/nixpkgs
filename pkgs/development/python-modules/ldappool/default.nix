{ lib
, buildPythonPackage
, fetchPypi
, pbr
, python-ldap
, prettytable
, six
, fixtures
, testresources
, testtools
}:

buildPythonPackage rec {
  pname = "ldappool";
  version = "3.0.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "ldappool";
    inherit version;
    sha256 = "4bb59b7d6b11407f48ee01a781267e3c8ba98d91f426806ac7208612ae087b86";
  };

  postPatch = ''
    # Tests run without most of the dependencies
    echo "" > test-requirements.txt
    # PrettyTable is now maintained again
    substituteInPlace requirements.txt --replace "PrettyTable<0.8,>=0.7.2" "PrettyTable"
  '';

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [ python-ldap prettytable six ];

  nativeCheckInputs = [ fixtures testresources testtools ];

  meta = with lib; {
    description = "A simple connector pool for python-ldap";
    homepage = "https://opendev.org/openstack/ldappool/";
    license = with licenses; [ mpl11 lgpl21Plus gpl2Plus ];
  };
}
