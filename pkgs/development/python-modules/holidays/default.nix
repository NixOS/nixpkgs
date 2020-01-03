{ stdenv, buildPythonPackage, fetchPypi , six, dateutil }:

buildPythonPackage rec {
  pname = "holidays";
  version = "0.9.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1g0irhh4kq3zy1disc9i5746p72a72s5j1q1cxhbdkwnnn9dnpwi";
  };

  propagatedBuildInputs = [ six dateutil ];

  meta = with stdenv.lib; {
    homepage = https://github.com/dr-prodigy/python-holidays;
    description = "Generate and work with holidays in Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
