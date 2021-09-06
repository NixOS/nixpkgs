{ lib, buildPythonApplication, fetchPypi, callPackage
, pbr, dulwich, sphinx
}:

buildPythonApplication rec {
  pname = "openstack-docstheme";
  version = "2.3.0";

  src = fetchPypi {
    pname = "openstackdocstheme";
    inherit version;
    sha256 = "dbdd237e40f660c86a5fe8c3d16db99e2c8471db2d7575981d5a02ce1977cf77";
  };

  propagatedBuildInputs = [
    pbr
    dulwich
    sphinx
  ];

  doCheck = false;

  pythonImportsCheck = [ "openstackdocstheme" ];

  meta = with lib; {
    description = "Sphinx theme for RST-sourced documentation published to docs.openstack.org";
    downloadPage = "https://pypi.org/project/openstackdocstheme/";
    homepage = "https://github.com/openstack/openstackdocstheme/";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj ];
  };
}
