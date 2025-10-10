{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  rstr,
  python,
}:

buildPythonPackage rec {
  pname = "raspyrfm-client";
  version = "1.2.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "markusressel";
    repo = "raspyrfm-client";
    tag = "v${version}";
    hash = "sha256-WiL69bb4h8xVdMYxAVU0NHEfTWyW2NVR86zigsr5dmk=";
  };

  # while we may not actually be on master, the script needs a git branch to function
  # and master here is better than beta or pre-alpha
  postPatch = ''
    substituteInPlace ./setup.py \
      --replace-fail 'subprocess.check_output(["git", "rev-parse", "--abbrev-ref", "HEAD"])' '"master"' \
      --replace-fail 'GIT_BRANCH.decode()' '"master"' \
      --replace-fail 'GIT_BRANCH.rstrip()' '"master"'
  '';

  build-system = [ setuptools ];

  pythonImportsCheck = [ "raspyrfm_client" ];

  nativeCheckInputs = [ rstr ];

  # pytestCheckHook does not auto detect the only test, run manually
  checkPhase = ''
    runHook preCheck

    ${python.interpreter} tests/automatic_tests.py

    runHook postCheck
  '';

  meta = {
    description = "Send rc signals with the RaspyRFM module";
    homepage = "https://github.com/markusressel/raspyrfm-client";
    changelog = "https://github.com/markusressel/raspyrfm-client/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
