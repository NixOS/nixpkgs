{ lib, fetchPypi, buildPythonPackage, pbr, six, sympy }:

buildPythonPackage rec {
  pname = "measurement";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "36ca385ffdccf140a75a7e1d816a4df97a6dd255f16fd2f53dd7ab43632a8835";
  };

  propagatedBuildInputs = [ pbr six sympy ];

  meta = with lib; {
    description = "Use and manipulate unit-aware measurement objects in Python";
    homepage = https://github.com/coddingtonbear/python-measurement;
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
