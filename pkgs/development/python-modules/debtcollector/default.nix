{ lib, buildPythonPackage, fetchPypi
, pbr, six, wrapt
, stestr }:

buildPythonPackage rec {
  pname = "debtcollector";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ab8ic9bk644i8134z044kpcf6pvawqf4rq4xgv1p11msbs82ybq";
  };

  propagatedBuildInputs = [
    pbr
    six
    wrapt
  ];

  checkInputs = [ stestr ];
  checkPhase = ''
    stestr run
  '';
  pythonImportsCheck = [ "debtcollector" ];

  meta = with lib; {
    description = "A collection of deprecation patterns and strategies that help you collect your technical debt in a non-destructive manner";
    homepage = "https://docs.openstack.org/debtcollector/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ angustrau ];
  };
}
