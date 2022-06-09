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

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-oz3cu9LsItm8fXa3Hdd4lsVXIhFT0UKHWXgLX7j+j6M=";
  };

  propagatedBuildInputs = [
    requests
    six
  ];

  # Tests need a running owncloud instance, would need a nixos integration test
  doCheck = false;

  pythonImportsCheck = [
    "owncloud"
  ];

  meta = with lib; {
    description = "Connect to an ownCloud instance";
    longDescription = ''
      This pure python library makes it possible to connect to an ownCloud instance and perform file, share and attribute operations.
    '';
    homepage = "https://github.com/owncloud/pyocclient/";
    changelog = "https://github.com/owncloud/pyocclient/blob/v${version}/docs/source/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ neosimsim turion ];
  };
}
