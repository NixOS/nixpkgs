{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pylutron";
  version = "0.2.11";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9M7bCZD3zGZM62ID0yB/neKkF+6UW8x5m2y5vj/mYes=";
  };

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pylutron" ];

  meta = with lib; {
    description = "Python library for controlling a Lutron RadioRA 2 system";
    homepage = "https://github.com/thecynic/pylutron";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
