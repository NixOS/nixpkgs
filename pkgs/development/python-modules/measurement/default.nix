{ lib, fetchPypi, buildPythonPackage, pbr, six, sympy }:

buildPythonPackage rec {
  pname = "measurement";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "352b20f7f0e553236af7c5ed48d091a51cf26061c1a063f46b31706ff7c0d57a";
  };

  propagatedBuildInputs = [ pbr six sympy ];

  meta = with lib; {
    description = "Use and manipulate unit-aware measurement objects in Python";
    homepage = https://github.com/coddingtonbear/python-measurement;
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
