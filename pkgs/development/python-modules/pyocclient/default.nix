{ lib
, buildPythonPackage
, fetchPypi
, dash
, requests
, six
}:

buildPythonPackage rec {
  pname = "pyocclient";
  version = "0.6";

  buildInputs = [
    requests
    six
  ];

  # Tests need a running owncloud instance, would need a nixos integration test
  doCheck = false;

  pythonImportsCheck = [
    "owncloud"
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-oz3cu9LsItm8fXa3Hdd4lsVXIhFT0UKHWXgLX7j+j6M=";
  };

  meta = with lib; {
    description = "Connect to an ownCloud instance";
    longDescription = ''
      This pure python library makes it possible to connect to an ownCloud instance and perform file, share and attribute operations.
    '';
    homepage = "https://github.com/owncloud/pyocclient/";
    changelog = "https://raw.githubusercontent.com/owncloud/pyocclient/master/docs/source/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ neosimsim turion ];
  };
}
