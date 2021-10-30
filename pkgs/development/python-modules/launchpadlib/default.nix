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
  version = "1.10.15.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4891f5b0c9bafbbb78aa06eeba1635629663c6aa80f621bcd1fc1057c8dd14b5";
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

  checkInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  doCheck = isPy3k;

  meta = with lib; {
    description = "Script Launchpad through its web services interfaces. Officially supported";
    homepage = "https://help.launchpad.net/API/launchpadlib";
    license = licenses.lgpl3Only;
    maintainers = [ maintainers.marsam ];
  };
}
