{ lib
, buildPythonPackage
, fetchPypi
, dulwich
, pbr
, sphinx
}:

buildPythonPackage rec {
  pname = "openstackdocstheme";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-csbU+am2OXp4xJ60P4Cp2i7TCz+PnRg3BCcc9+PyPM8=";
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
