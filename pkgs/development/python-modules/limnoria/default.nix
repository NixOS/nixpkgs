{
  lib,
  buildPythonPackage,
  setuptools,
  chardet,
  cryptography,
  feedparser,
  fetchPypi,
  mock,
  pysocks,
  pytestCheckHook,
  python-dateutil,
  python-gnupg,
  pythonOlder,
  pytz,
}:

buildPythonPackage rec {
  pname = "limnoria";
<<<<<<< HEAD
  version = "2025.11.2";
=======
  version = "2025.7.18";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-cvlp1cfsdN8lv8hFvaHV6vtWEJ0CJUBmN1yCgxrhMi8=";
=======
    hash = "sha256-iXu+ObOFd0iQae8/mY2ztt7s4kuKutX3huHN7jP3cHE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    chardet
    cryptography
    feedparser
    mock
    pysocks
    python-dateutil
    python-gnupg
  ]
  ++ lib.optionals (pythonOlder "3.9") [ pytz ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "version=version" 'version="${version}"'
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

<<<<<<< HEAD
  meta = {
    description = "Modified version of Supybot, an IRC bot";
    homepage = "https://github.com/ProgVal/Limnoria";
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    description = "Modified version of Supybot, an IRC bot";
    homepage = "https://github.com/ProgVal/Limnoria";
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
