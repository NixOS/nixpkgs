{ stdenv, buildPythonPackage, fetchPypi, numpy, cython }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pyemd";
  version = "0.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13y06y7r1697cv4r430g45fxs40i2yk9xn0dk9nqlrpddw3a0mr4";
  };

  propagatedBuildInputs = [ numpy ];
  buildInputs = [ cython ];

  meta = with stdenv.lib; {
    description = "A Python wrapper for Ofir Pele and Michael Werman's implementation of the Earth Mover's Distance";
    homepage = https://github.com/wmayner/pyemd;
    license = licenses.mit;
    maintainers = with maintainers; [ rvl ];
  };
}
