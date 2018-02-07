{ stdenv, buildPythonPackage, fetchPypi
, cython, pytest, numpy, scipy, matplotlib, pandas, tabulate }:

buildPythonPackage rec {
  pname = "acoustics";
  version = "0.1.2";
  name = "${pname}-${version}";

  buildInputs = [ cython pytest ];
  propagatedBuildInputs = [ numpy scipy matplotlib pandas tabulate ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "b75a47de700d01e704de95953a6e969922b2f510d7eefe59f7f8980ad44ad1b7";
  };

  # Tests not distributed
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A package for acousticians";
    maintainers = with maintainers; [ fridh ];
    license = with licenses; [ bsd3 ];
    homepage = https://github.com/python-acoustics/python-acoustics;
  };
}
