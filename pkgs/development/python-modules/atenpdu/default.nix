{ lib
, buildPythonPackage
, fetchPypi
, pysnmp
}:

buildPythonPackage rec {
  pname = "atenpdu";
  version = "0.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/duY1hS+RU/UAdcQoHF1+c99XaN74jj/0Hj/86U0kmo=";
  };

  propagatedBuildInputs = [ pysnmp ];

  # Project has no test
  doCheck = false;
  pythonImportsCheck = [ "atenpdu" ];

  meta = with lib; {
    description = "Python interface to control ATEN PE PDUs";
    homepage = "https://github.com/mtdcr/pductl";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
