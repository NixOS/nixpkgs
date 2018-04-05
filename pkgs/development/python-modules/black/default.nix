{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, attrs, click }:

buildPythonPackage rec {
  pname = "black";
  version = "18.4a0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04dffr4wmzs4vf2xj0cxp03hv04x0kk06qyzx6jjrp1mq0z3n2rr";
  };

  propagatedBuildInputs = [ attrs click ];

  meta = with stdenv.lib; {
    description = "The uncompromising Python code formatter";
    homepage    = https://github.com/ambv/black;
    license     = licenses.mit;
    maintainers = with maintainers; [ sveitser ];
  };

}
