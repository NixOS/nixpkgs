{ lib
, fetchPypi
, buildPythonPackage
, requests-toolbelt
}:

buildPythonPackage rec {
  pname = "pyfcm";
  version = "1.4.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cce6c999d8ffe39a44c42329f40c73306586102c6379fc726ea217070b72b967";
  };

  propagatedBuildInputs = [ requests-toolbelt ];

  # Pypi does not provide test files
  doCheck = false;

  meta = with lib; {
    description = "Python client for FCM - Firebase Cloud Messaging (Android, iOS and Web)";
    homepage = "https://github.com/olucurious/pyfcm";
    license = licenses.mit;
  };
}
