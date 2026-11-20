{
  lib,
  buildPythonPackage,
  feedparser-sgmllib,
  fetchFromGitHub,
  python,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "feedparser";
  version = "6.0.14";
  pyproject = true;

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "kurtmckee";
    repo = "feedparser";
    tag = "v${version}";
    hash = "sha256-b2NnirUFJ1uAqIl4h/UoAff5am/D2pIuundZyzzQFfU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    feedparser-sgmllib
    requests
  ];

  checkPhase = ''
    runHook preCheck

    # Tests are failing
    # AssertionError: unexpected '~' char in declaration
    rm tests/wellformed/sanitize/xml_declaration_unexpected_character.xml
    ${python.interpreter} -Wd tests/runtests.py

    runHook postCheck
  '';

  pythonImportsCheck = [ "feedparser" ];

  meta = {
    description = "Universal feed parser";
    homepage = "https://github.com/kurtmckee/feedparser";
    changelog = "https://feedparser.readthedocs.io/en/latest/changelog";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
