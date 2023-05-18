{ lib, buildPythonPackage, fetchPypi, debtcollector, oslotest, stestr, pbr }:

buildPythonPackage rec {
  pname = "oslo.context";
  version = "5.1.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ly55FxBE79GAfFVxPtLH9AaLGNc9AngZFlxIGbKHz68=";
  };

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  propagatedBuildInputs = [
    debtcollector
    pbr
  ];

  nativeCheckInputs = [
    oslotest
    stestr
  ];

  checkPhase = ''
    stestr run
  '';

  pythonImportsCheck = [ "oslo_context" ];

  meta = with lib; {
    description = "Oslo Context library";
    homepage = "https://github.com/openstack/oslo.context";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
