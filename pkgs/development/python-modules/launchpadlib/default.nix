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
}:

buildPythonPackage rec {
  pname = "launchpadlib";
  version = "1.10.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "740580d72611452804ad7735c9af6944ed4a14fc1a2fcbcddba3fc719b5317f3";
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

  preCheck = ''
    export HOME=$TMPDIR
  '';

  doCheck = isPy3k;

  meta = with lib; {
    description = "Script Launchpad through its web services interfaces. Officially supported";
    homepage = "https://help.launchpad.net/API/launchpadlib";
    license = licenses.lgpl3;
    maintainers = [ maintainers.marsam ];
  };
}
