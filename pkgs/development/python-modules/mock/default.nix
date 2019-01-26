{ stdenv
, buildPythonPackage
, fetchPypi
, unittest2
, funcsigs
, six
, pbr
, python
}:

buildPythonPackage rec {
  pname = "mock";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1flbpksir5sqrvq2z0dp8sl4bzbadg21sj4d42w3klpdfvgvcn5i";
  };

  buildInputs = [ unittest2 ];
  propagatedBuildInputs = [ funcsigs six pbr ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = with stdenv.lib; {
    description = "Mock objects for Python";
    homepage = http://python-mock.sourceforge.net/;
    license = stdenv.lib.licenses.bsd2;
  };

}
