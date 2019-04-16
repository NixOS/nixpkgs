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
  version = "0.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8a7f803f06083d4106d55387d2daa32c12b5e376c3616b0e2da8b8a87a27d74a";
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
