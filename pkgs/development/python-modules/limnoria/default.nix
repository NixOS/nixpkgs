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
  pytz,
}:

buildPythonPackage (finalAttrs: {
  pname = "limnoria";
  version = "2026.1.16";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ZkEXZMjJsEgSwX2a8TwaQ/vtvskSOFwNBZg/Ru5q/bc=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "version=version" 'version="${finalAttrs.version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    chardet
    cryptography
    feedparser
    mock
    pysocks
    python-dateutil
    python-gnupg
  ];

  nativeCheckInputs = [ pytestCheckHook ];

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
    changelog = "https://github.com/progval/Limnoria/releases/tag/master-${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
