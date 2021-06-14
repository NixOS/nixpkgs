{ lib
, buildPythonPackage
, fetchPypi
, pysnmp
}:

buildPythonPackage rec {
  pname = "atenpdu";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1np9p3d180c26p54nw33alb003lhx6fprr21h45dd8gqk3slm13c";
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
