{
  lib,
  cachetools,
  frozendict,
  lxml,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  requests,
  setuptools,
}:

let

  json-ld = fetchFromGitHub {
    owner = "w3c";
    repo = "json-ld-api";
    rev = "8ad03db5477e24b70a4ded898a1b2e18d6ab684b";
    hash = "sha256-M/Vr9muxSHQTHcgFXhg7kiQtIMGnpbl3QXIAE5KBv8k=";
  };

  json-ld-framing = fetchFromGitHub {
    owner = "w3c";
    repo = "json-ld-framing";
    rev = "dfda94cfdfb360d5b64ac047bdb8ef86ec7ea0f1";
    hash = "sha256-awn4cPF//wSe7kQ358bPwJY1HwcE25XhGbo5NrqkNXk=";
  };

  normalization = fetchFromGitHub {
    owner = "json-ld";
    repo = "normalization";
    rev = "fbcfce5730bf2726c131a84d06ffb686a190a969";
    hash = "sha256-a44vLPbWnbbR4kZa/jklCBvrPQwsllixsg0yZclhKls=";
  };
in

buildPythonPackage rec {
  pname = "pyld";
  version = "2.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "digitalbazaar";
    repo = "pyld";
    tag = "v${version}";
    hash = "sha256-XKPAGOLuLk2VOnvdICo2sNPdeoQok+oGScWXeuYmi4o=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cachetools
    frozendict
    lxml
    requests
  ];

  checkPhase = ''
    runHook preCheck

    cp -r --no-preserve=all ${json-ld}/tests json-ld-tests
    # We have no internet access
    substituteInPlace json-ld-tests/manifest.jsonld \
      --replace-fail '"remote-doc-manifest.jsonld",' ""
    patch -p1 <${./disable-tests-where-pyld-is-not-strict-enough.diff}

    ${python.interpreter} tests/runtests.py ${normalization}/tests ${json-ld-framing}/tests json-ld-tests

    runHook postCheck
  '';

  meta = {
    description = "Python implementation of the JSON-LD API";
    homepage = "https://github.com/digitalbazaar/pyld";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
