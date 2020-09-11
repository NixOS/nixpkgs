{ buildPythonPackage
, lib
, fetchPypi
, google-api-python-client
, oauth2client
, pyopenssl
, pyyaml
, six
}:

buildPythonPackage rec {
  pname = "pydrive2";
  version = "1.10.0";

  src = fetchPypi {
    pname = "PyDrive2";
    inherit version;
    sha256 = "1av3fkbq8xvrvshy8yiq6ysllwll1mfcaspv4aww1xhyzys1kggp";
  };

  propagatedBuildInputs = [
    google-api-python-client
    oauth2client
    pyopenssl
    pyyaml
    six
  ];

  pythonImportsCheck = [
    "googleapiclient"
    "oauth2client"
    "OpenSSL"
    "yaml"
    "six"
  ];

  # the tests require GCP credentials
  doCheck = false;

  meta = with lib; {
    description = "Google Drive API Python wrapper library";
    homepage = "https://github.com/iterative/PyDrive2";
    license = licenses.asl20;
    maintainers = with maintainers; [ stephenwithph ];
  };
}
