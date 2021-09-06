{ lib, buildPythonApplication, fetchPypi, pythonOlder
, pbr, six
}:

buildPythonApplication rec {
  pname = "openstack-oslo_i18n";
  version = "5.0.1";

  src = fetchPypi {
    pname = "oslo.i18n";
    inherit version;
    sha256 = "3484b71e30f75c437523302d1151c291caf4098928269ceec65ce535456e035b";
  };

  propagatedBuildInputs = [
    pbr
    six
  ];

  doCheck = false;

  pythonImportsCheck = [ "oslo_i18n" ];

  meta = with lib; {
    description = "Oslo i18n library";
    downloadPage = "https://pypi.org/project/oslo.i18n/";
    homepage = "https://github.com/openstack/oslo.i18n/";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj ];
  };
}
