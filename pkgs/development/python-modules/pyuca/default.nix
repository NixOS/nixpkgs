{ lib
, python
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pyuca";
  version = "1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1clk53mbw232wmwpa1sz73asl82ar89hg34h306qrw178vkjyf4a";
  };

  checkPhase = ''
    ${python.interpreter} ./test.py
  '';

  doCheck = false; # tests missing from PyPI (https://github.com/jtauber/pyuca/issues/21)

  meta = with lib; {
    description = "Python implementation of the Unicode Collation Algorithm";
    homepage = http://github.com/jtauber/pyuca;
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
  };
}
