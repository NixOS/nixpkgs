{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  zope-testrunner,
}:

buildPythonPackage rec {
  pname = "zope-deprecation";
  version = "6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.deprecation";
    tag = version;
    hash = "sha256-N/+RtilRY/8NfhUjd/Y4T6dmZHt6PW4ofP1UE8Aj1e8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools ==" "setuptools >="
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [ zope-testrunner ];

  checkPhase = ''
    runHook preCheck

    zope-testrunner --test-path=src

    runHook postCheck
  '';

  pythonImportsCheck = [ "zope.deprecation" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    homepage = "https://github.com/zopefoundation/zope.deprecation";
    description = "Zope Deprecation Infrastructure";
    changelog = "https://github.com/zopefoundation/zope.deprecation/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
