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
  version = "1.10.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0df4b13936f988afd0ee485f40fa6922eab783b48c38ca0108cb73c8788fca80";
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
