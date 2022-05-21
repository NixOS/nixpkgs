{ lib
, async-timeout
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
, urllib3
, validators
, yarl
}:

buildPythonPackage rec {
  pname = "dremel3dpy";
  version = "0.3.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zKbHKdgMx76cYGPvPVSm39si0LfyDA4L1CcKaQzEpCw=";
  };

  propagatedBuildInputs = [
    async-timeout
    requests
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
