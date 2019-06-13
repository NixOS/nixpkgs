{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, python
, snappy
, cffi
, nose
}:

buildPythonPackage rec {
  pname = "python-snappy";
  version = "0.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d9c26532cfa510f45e8d135cde140e8a5603d3fb254cfec273ebc0ecf9f668e2";
  };

  buildInputs = [ snappy ];

  propagatedBuildInputs = lib.optional isPyPy cffi;

  checkInputs = [ nose ];

  checkPhase = ''
    rm -r snappy # prevent local snappy from being picked up
    nosetests test_snappy.py
  '' + lib.optionalString isPyPy ''
    nosetests test_snappy_cffi.py
  '';

  meta = with lib; {
    description = "Python library for the snappy compression library from Google";
    homepage = https://github.com/andrix/python-snappy;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
