{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  setuptools,
  cachetools,
  frozendict,
  lxml,
  requests,
}:

let
  json-ld-api = fetchFromGitHub {
    owner = "w3c";
    repo = "json-ld-api";
    rev = "b0f78df0399a3ceaee8b7a49c38eb17caa601524";
    hash = "sha256-g0FZM9LpZGmliG5DEkKv2YDEBRiKArVXy8hJgTRIzrI=";
  };

  json-ld-framing = fetchFromGitHub {
    owner = "w3c";
    repo = "json-ld-framing";
    rev = "118f1a11507fb4bdbd5e517b85bc93ca741d2aeb";
    hash = "sha256-9JiyRjkBzzawxEVAKGExRHVce7Zo+yKaHauHgNX5Pxc=";
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
    requests # default loader
  ];

  # Unfortunately PyLD does not pass all testcases in the JSON-LD corpus. We
  # check for at least a minimum amount of successful tests so we know it's not
  # getting worse, at least.
  checkPhase = ''
    ok_min=1311
    if ! ${python.interpreter} tests/runtests.py ${json-ld-api}/tests ${json-ld-framing}/tests 2>&1 | tee test.out; then
      ok_count=$(grep -F '... ok' test.out | wc -l)
      if [[ $ok_count -lt $ok_min ]]; then
        echo "Less than $ok_min tests passed ($ok_count). Failing the build."
        exit 1
      fi
    fi

    ${python.interpreter} tests/runtests.py ${normalization}/tests
  '';

  pythonImportsCheck = [ "pyld" ];

  meta = {
    description = "Python implementation of the JSON-LD API";
    homepage = "https://github.com/digitalbazaar/pyld";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
