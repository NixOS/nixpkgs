{ lib
, buildPythonPackage
, chardet
, cryptography
, feedparser
, fetchPypi
, mock
, pysocks
, pytestCheckHook
, python-dateutil
, python-gnupg
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "limnoria";
  version = "2022.8.7";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TRTqhWQSVhjJkd9FLJk1lDwdzyzkeih9zHPSOvTf2oQ=";
  };

  propagatedBuildInputs = [
    chardet
    cryptography
    feedparser
    mock
    pysocks
    python-dateutil
    python-gnupg
  ] ++ lib.optionals (pythonOlder "3.9") [
    pytz
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version=version" 'version="${version}"'
  '';

  checkPhase = ''
    runHook preCheck
    export PATH="$PATH:$out/bin";
    supybot-test test -v --no-network
    runHook postCheck
  '';

  pythonImportsCheck = [
    # Uses the same names as Supybot
    "supybot"
  ];

  meta = with lib; {
    description = "A modified version of Supybot, an IRC bot";
    homepage = "https://github.com/ProgVal/Limnoria";
    license = licenses.bsd3;
    maintainers = with maintainers; [ goibhniu ];
  };
}
