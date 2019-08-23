{ stdenv, fetchPypi, buildPythonPackage, tkinter }:

buildPythonPackage rec {
  pname = "PyMsgBox";
  version = "1.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kmd00w7p6maiyqpqqb2j8m6v2gh9c0h5i198pa02bc1c1m1321q";
    extension = "zip";
  };

  propagatedBuildInputs = [ tkinter ];

  # Finding tests fails
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A simple, cross-platform, pure Python module for JavaScript-like message boxes";
    homepage = https://github.com/asweigart/PyMsgBox;
    license = licenses.bsd3;
    maintainers = with maintainers; [ jluttine ];
  };
}
