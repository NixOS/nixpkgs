{ lib
, buildPythonPackage
, fetchPypi
, dulwich
, pbr
, sphinx
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "openstackdocstheme";
  version = "3.2.0";
  format = "setuptools";

  # breaks on import due to distutils import through pbr.packaging
  disabled = pythonAtLeast "3.12";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PwSWLJr5Hjwz8cRXXutnE4Jc+vLcL3TJTZl6biK/4E4=";
  };

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  propagatedBuildInputs = [ dulwich pbr sphinx ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "openstackdocstheme" ];

  meta = with lib; {
    description = "Sphinx theme for RST-sourced documentation published to docs.openstack.org";
    homepage = "https://github.com/openstack/openstackdocstheme";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
