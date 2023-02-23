{ lib
, buildPythonPackage
, fetchPypi

# propagates
, pycryptodome
, requests
, rtp
, urllib3
}:

buildPythonPackage rec {
  pname = "pytapo";
  version = "3.1.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SV9jj4N+6ggvYTz96iAiI4T7GikgGpDzFo4gIOYETU0=";
  };

  propagatedBuildInputs = [
    pycryptodome
    requests
    rtp
    urllib3
  ];

  pythonImportsCheck = [
    "pytapo"
  ];

  # Tests require actual hardware
  doCheck = false;

  meta = with lib; {
    description = "Python library for communication with Tapo Cameras ";
    homepage = "https://github.com/JurajNyiri/pytapo";
    license = licenses.mit;
    maintainers = with maintainers; [ fleaz ];
  };
}
