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
  version = "2024.5.30";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uKJMeC1dXhQp1CGbtdnqmELFO64VWblhABGfpKHGCZQ=";
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
  ] ++ lib.optionals (pythonOlder "3.9") [ pytz ];

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

  meta = with lib; {
    description = "Modified version of Supybot, an IRC bot";
    homepage = "https://github.com/ProgVal/Limnoria";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
