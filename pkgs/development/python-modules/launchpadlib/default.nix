{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, httplib2
, keyring
, lazr-restfulclient
, lazr-uri
, setuptools
, six
, testresources
, wadllib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "launchpadlib";
  version = "1.10.18";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uFRv4XrKUUfSRq0gd4xKVUTrR6+RsYUVJDePpo8tcmQ=";
  };

  propagatedBuildInputs = [
    httplib2
    keyring
    lazr-restfulclient
    lazr-uri
    setuptools
    six
    testresources
    wadllib
  ];

  checkInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  doCheck = isPy3k;

  pythonImportsCheck = [
    "launchpadlib"
    "launchpadlib.apps"
    "launchpadlib.credentials"
  ];

  meta = with lib; {
    description = "Script Launchpad through its web services interfaces. Officially supported";
    homepage = "https://help.launchpad.net/API/launchpadlib";
    license = licenses.lgpl3Only;
    maintainers = [ maintainers.marsam ];
  };
}
