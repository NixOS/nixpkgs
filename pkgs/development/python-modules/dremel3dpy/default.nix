{ lib
, async-timeout
, buildPythonPackage
, fetchPypi
, imageio
, imutils
, pythonOlder
, requests
, urllib3
, tqdm
, validators
, yarl
}:

buildPythonPackage rec {
  pname = "dremel3dpy";
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+gw7JBr4/u7iaxo6DTiCQGq58eBkp6SYX6Z/Lyv+T90=";
  };

  propagatedBuildInputs = [
    async-timeout
    imageio
    imutils
    requests
    tqdm
    urllib3
    validators
    yarl
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "dremel3dpy"
  ];

  meta = with lib; {
    description = "Module for interacting with Dremel 3D printers";
    homepage = "https://github.com/godely/dremel3dpy";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
