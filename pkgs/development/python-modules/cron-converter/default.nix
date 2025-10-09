{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  unittestCheckHook,
  setuptools,
  python-dateutil,
  python,
}:
buildPythonPackage rec {
  pname = "cron-converter";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Sonic0";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XpkpEMurRrhq1S4XnhPRW5CCBk+HzljOSQfZ98VJ7UE=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [ python-dateutil ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s tests/unit -v
    ${python.interpreter} -m unittest discover -s tests/integration -v
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
