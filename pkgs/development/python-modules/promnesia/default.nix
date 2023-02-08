{ buildPythonPackage
, fetchPypi
, lib
, beautifulsoup4
, cachew
, fastapi
, HPI
, httptools
, logzero
, lxml
, mistletoe
, more-itertools
, mypy
, orgparse
, pytz
, setuptools
, setuptools-scm
, sqlcipher3
, tzlocal
, urlextract
, uvicorn
, uvloop
, watchfiles
, websockets
}:

buildPythonPackage rec {
  pname = "promnesia";
  version = "1.1.20230129";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-T6sayrPkz8I0u11ZvFbkDdOyVodbaTVkRzLib5lMX+Q=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    beautifulsoup4
    cachew
    fastapi
    HPI
    httptools
    logzero
    lxml
    mistletoe
    more-itertools
    mypy
    orgparse
    pytz
    setuptools
    sqlcipher3
    tzlocal
    urlextract
    uvicorn
    uvloop
    watchfiles
    websockets
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/karlicoss/promnesia";
    description = "Another piece of your extended mind";
    license = licenses.mit;
    maintainers = with maintainers; [ qbit ];
  };
}
