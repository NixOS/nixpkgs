{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  python-dateutil,
  python,
}:
buildPythonPackage rec {
  pname = "cron-converter";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Sonic0";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-o5rqzOP1svAMj0R6qhMui3uYgyEJEGQOaA8cy5U77hk=";
  };

  postPatch = ''
    # Timezone does not match
    substituteInPlace tests/integration/tests_cron_seeker.py \
      --replace-fail "test_timezone" "dont_test_timezone"
  '';

  build-system = [ setuptools ];

  dependencies = [ python-dateutil ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m unittest discover -s tests/unit -v
    ${python.interpreter} -m unittest discover -s tests/integration -v
    runHook postCheck
  '';

  pythonImportsCheck = [ "cron_converter" ];

  meta = with lib; {
    description = "Cron string parser and iteration for the datetime object with a cron like format";
    homepage = "https://github.com/Sonic0/cron-converter";
    changelog = "https://github.com/Sonic0/cron-converter/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ b4dm4n ];
  };
}
