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
  version = "1.10.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5804d68ec93247194449d17d187e949086da0a4d044f12155fad269ef8515435";
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
