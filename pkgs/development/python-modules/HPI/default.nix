{ buildPythonPackage
, fetchPypi
, lib
, appdirs
, click
, decorator
, logzero
, lxml 
, more-itertools
, mypy
, orjson
, pandas
, pytz
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "HPI";
  version = "0.0.20200417";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-cozMmfBF7D1qCZFjf48wRQaeN4MhdHAAxS8tGp/krK8=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    appdirs
    click
    decorator
    logzero
    lxml
    more-itertools
    mypy
    orjson
    pandas
    pytz
  ];

  meta = with lib; {
    description = "Human programming interface";
    homepage = "https://beepb00p.xyz/hpi.html";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ qbit ];
  };
}
