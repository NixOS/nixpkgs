{ lib, buildPythonPackage, fetchPypi
, pbr, debtcollector
, stestr, oslotest }:

buildPythonPackage rec {
  pname = "oslo-context";
  version = "3.3.0";

  src = fetchPypi {
    inherit version;
    pname = "oslo.context";
    sha256 = "027w23sspvwx0669an9jrzi17chn5jl5jbgyab1k21zfg670jgyq";
  };

  propagatedBuildInputs = [
    pbr
    debtcollector
  ];

  checkInputs = [ stestr oslotest ];
  checkPhase = ''
    stestr run
  '';
  pythonImportsCheck = [ "oslo_context" ];

  meta = with lib; {
    description = "Oslo Context library";
    homepage = "https://docs.openstack.org/oslo.context/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ angustrau ];
  };
}
