{ lib, buildPythonApplication, fetchPypi
, pbr, openstack-debtcollector
}:

buildPythonApplication rec {
  pname = "openstack-oslo_context";
  version = "3.3.1";

  src = fetchPypi {
    pname = "oslo.context";
    inherit version;
    sha256 = "f578ea38569cf0a677e2167178196b21a54175471358c4320ddfd5c97c52f4d1";
  };

  propagatedBuildInputs = [
    pbr
    openstack-debtcollector
  ];

  doCheck = false;

  pythonImportsCheck = [ "oslo_context" ];

  meta = with lib; {
    description = "Oslo Context library";
    downloadPage = "https://pypi.org/project/oslo.context";
    homepage = "https://github.com/openstack/oslo.context/";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj ];
  };
}
