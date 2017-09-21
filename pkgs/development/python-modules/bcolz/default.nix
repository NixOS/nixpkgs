{ stdenv, buildPythonPackage, fetchPypi, numpy, mock, setuptools_scm, cython, isPy3k }:

buildPythonPackage rec {
  pname = "bcolz";
  version = "1.1.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ws0b9p1r4gcxic7fm8clm2q2ily3bd6i4giczw4s6gv5ilk7ds2";
  };

  doCheck = !isPy3k;

  buildInputs = [ setuptools_scm cython ];
  propagatedBuildInputs = [ numpy mock ];

  meta = with stdenv.lib; {
    description = "A columnar data container that can be compressed";
    homepage = "https://github.com/Blosc/bcolz";
    maintainers = with maintainers; [ gabesoft ];
    license = licenses.bsd3;
  };
}
