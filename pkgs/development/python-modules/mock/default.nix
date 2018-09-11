{ stdenv
, buildPythonPackage
, fetchPypi
, python
, unittest2
, funcsigs
, six
, pbr
, isPy3k
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mock";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b158b6df76edd239b8208d481dc46b6afd45a846b7812ff0ce58971cf5bc8bba";
  };

  checkInputs = [ unittest2 ];
  propagatedBuildInputs = [ pbr six ]
    ++ stdenv.lib.optionals (pythonOlder "3.3") [ funcsigs ];

  checkPhase = ''
   unit2
  '';

  meta = with stdenv.lib; {
    description = "Mock objects for Python";
    homepage = http://python-mock.sourceforge.net/;
    license = licenses.bsd2;
    maintainers = [ maintainers.costrouc ];
  };
}
