{ stdenv
, buildPythonPackage
, fetchPypi
, pbr
, pyyaml
, six
, dulwich
, hacking
, mock
, coverage
, subunit
, openstackdocstheme
, testrepository
, testscenarios
, testtools
, sphinx
}:

buildPythonPackage rec {
  version = "2.10.0";
  pname = "reno";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11335394139e57bf14856a233d4b02689f3290b9be09d91c1909dc4cada48822";
  };

  checkInputs = [ hacking mock coverage subunit openstackdocstheme testrepository testscenarios testtools sphinx ];
  propagatedBuildInputs = [ pbr pyyaml six dulwich ];

  # checks require git repository
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://docs.openstack.org/reno/latest/;
    description = "RElease NOtes manager";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
