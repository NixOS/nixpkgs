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
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wqfCzS9dhRN/zerrC6g/O8tn0k1IC0wBdZMfWumtBds=";
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

  postPatch = ''
    # Ignore the pinning
    sed -i -e "s/==[0-9.]*//" setup.py
  '';

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
