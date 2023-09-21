{ lib
, buildPythonPackage
, cython
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "murmurhash";
  version = "1.0.10";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UoKqsTF4BMbr1t1/afFbqQda7mccRKNL4r3g8bEe+Io=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'wheel>=0.32.0,<0.33.0'" ""
  '';

  buildInputs = [
   cython
  ];

  # No test
  doCheck = false;

  pythonImportsCheck = [
    "murmurhash"
  ];

  meta = with lib; {
    description = "Cython bindings for MurmurHash2";
    homepage = "https://github.com/explosion/murmurhash";
    license = licenses.mit;
    maintainers = with maintainers; [ aborsu ];
  };
}
