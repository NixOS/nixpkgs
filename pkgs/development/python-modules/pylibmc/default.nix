{ lib
, buildPythonPackage
, cyrus_sasl
, fetchPypi
, libmemcached
, zlib
}:

buildPythonPackage rec {
  pname = "pylibmc";
  version = "1.6.2";
  format = "setuptools";

  disabled = pythonAtLeast "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QatJ05VAdnN0iRvvC+tSkcqXvrcEi3r3dSEGSVPATcA=";
  };

  buildInputs = [
    cyrus_sasl
    libmemcached
    zlib
  ];

  setupPyBuildFlags = [
    "--with-sasl2"
  ];

  # Requires an external memcached server running
  doCheck = false;

  pythonImportsCheck = [
    "pylibmc"
  ];

  meta = with lib; {
    description = "Quick and small memcached client for Python";
    homepage = "http://sendapatch.se/projects/pylibmc/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
