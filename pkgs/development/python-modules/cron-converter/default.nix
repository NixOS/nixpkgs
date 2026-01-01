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
<<<<<<< HEAD
  version = "1.3.1";
=======
  version = "1.2.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Sonic0";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-zNDEBckvSwnqBfNyh5Gv7ICOsPaSx2NKl92ZlyDfukw=";
=======
    hash = "sha256-XpkpEMurRrhq1S4XnhPRW5CCBk+HzljOSQfZ98VJ7UE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Cron string parser and iteration for the datetime object with a cron like format";
    homepage = "https://github.com/Sonic0/cron-converter";
    changelog = "https://github.com/Sonic0/cron-converter/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ b4dm4n ];
=======
  meta = with lib; {
    description = "Cron string parser and iteration for the datetime object with a cron like format";
    homepage = "https://github.com/Sonic0/cron-converter";
    changelog = "https://github.com/Sonic0/cron-converter/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ b4dm4n ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
