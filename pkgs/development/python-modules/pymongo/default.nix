{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pythonOlder
, dnspython
}:

buildPythonPackage rec {
  pname = "pymongo";
  version = "4.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aB8lLkOz7wVMqRYWNfgbcw9NjK3Siz8rIAT1py+FOYI=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2024-21506.patch";
      url = "https://github.com/mongodb/mongo-python-driver/commit/372b5d68d5a57ccc43b33407cd23f0bc79d99283.patch";
      hash = "sha256-fv7zKSAap7WlRYvD+FSz83XFJwswID1ntYRoHO1g2Lg=";
    })
  ];

  propagatedBuildInputs = [
    dnspython
  ];

  # Tests call a running mongodb instance
  doCheck = false;

  pythonImportsCheck = [ "pymongo" ];

  meta = with lib; {
    description = "Python driver for MongoDB";
    homepage = "https://github.com/mongodb/mongo-python-driver";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
