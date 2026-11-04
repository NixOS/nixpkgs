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
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Sonic0";
    repo = "cron-converter";
    rev = "v${version}";
    hash = "sha256-e5e5UqFu13WfKkRo9v6yFhDCiCi2Vj8U/fKZqFttcHE=";
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

  meta = {
    description = "Cron string parser and iteration for the datetime object with a cron like format";
    homepage = "https://github.com/Sonic0/cron-converter";
    changelog = "https://github.com/Sonic0/cron-converter/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ b4dm4n ];
  };
}
