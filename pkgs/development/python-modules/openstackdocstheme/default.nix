{ stdenv
, buildPythonPackage
, fetchPypi
, pbr
, dulwich
, hacking
, sphinx
}:

buildPythonPackage rec {
  version = "1.23.2";
  pname = "openstackdocstheme";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2390515687231ad199dfdcda742c677bc080fe6839c04fb22e367427863f114b";
  };

  checkInputs = [ hacking sphinx ];
  propagatedBuildInputs = [ pbr dulwich ];

  # hacking version is old
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://docs.openstack.org/openstackdocstheme/latest/;
    description = "OpenStack Docs Theme";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
