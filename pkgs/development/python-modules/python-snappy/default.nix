{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, snappy
, cffi
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "python-snappy";
  version = "0.6.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tqEHqwYgasxTWdTFYyvZsi1EhwKnmzFpsMYuD7gIuyo=";
  };

  buildInputs = [ snappy ];

  propagatedBuildInputs = lib.optional isPyPy cffi;

  nativeCheckInputs = [ unittestCheckHook ];

  meta = with lib; {
    description = "Python library for the snappy compression library from Google";
    homepage = "https://github.com/andrix/python-snappy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
