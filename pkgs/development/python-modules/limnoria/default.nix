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
  version = "2026.1.16";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZkEXZMjJsEgSwX2a8TwaQ/vtvskSOFwNBZg/Ru5q/bc=";
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

  meta = {
    description = "Modified version of Supybot, an IRC bot";
    homepage = "https://github.com/ProgVal/Limnoria";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
