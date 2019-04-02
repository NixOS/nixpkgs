{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, dulwich
, pbr
, sphinx
}:

buildPythonPackage rec{
  pname = "openstackdocstheme";
  version = "1.29.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d01b8b9af1789259fcc147d148e95ac00d94b3d829439ac6dd1dc9ec10651f5c";
  };

  buildInputs = [ dulwich pbr sphinx ];

  meta = with lib; {
    homepage = https://github.com/openstack/openstackdocstheme;
    description = "Sphinx theme for RST-sourced documentation published to docs.openstack.org";
    license = licenses.apache;
    maintainers = with maintainers; [ cptMikky ];
  };
}

