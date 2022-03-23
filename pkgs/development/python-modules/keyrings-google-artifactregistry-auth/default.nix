{ lib
, buildPythonPackage
, fetchPypi
, google-auth
, keyring
, pluggy
, requests
, setuptools-scm
, toml
}:

buildPythonPackage rec {
  pname = "keyrings.google-artifactregistry-auth";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gvoX5SP0A39Ke0VRlplETJF8gIP+QzK6xNReRxM8UnA=";
  };

  buildInputs = [
    setuptools-scm
    toml
  ];

  propagatedBuildInputs = [
    google-auth
    keyring
    pluggy
    requests
  ];

  pythonImportsCheck = [
    "keyrings.gauth"
  ];


  meta = with lib; {
    description = "Python package which allows you to configure keyring to interact with Python repositories stored in Artifact Registry";
    homepage = "https://pypi.org/project/keyrings.google-artifactregistry-auth";
    license = licenses.asl20;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
