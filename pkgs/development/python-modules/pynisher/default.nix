{ lib
, buildPythonPackage
, fetchPypi
, psutil
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "pynisher";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5FJQCN+yO1gh7HK47MRR/SAr8Qzix3bfrjyzsakBQXA=";
  };

  propagatedBuildInputs = [
    psutil
    typing-extensions
  ];

  # No tests in the Pypi archive
  doCheck = false;

  pythonImportsCheck = [
    "pynisher"
  ];

  meta = with lib; {
    description = "Module intended to limit a functions resources";
    homepage = "https://github.com/sfalkner/pynisher";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
