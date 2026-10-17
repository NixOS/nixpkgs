{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "time-decode";
  version = "10.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "digitalsleuth";
    repo = "time_decode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-icSMwPtJShFtzbzo0HaMaaq8yUdzJsuwJc3sHAzhsf4=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    bbpb
    colorama
    juliandate
    prettytable
    pyqt6
    python-dateutil
    python-ulid
    pytz
    tzdata
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "time_decode" ];

  meta = {
    description = "Timestamp and date decoder";
    homepage = "https://github.com/digitalsleuth/time_decode";
    changelog = "https://github.com/digitalsleuth/time_decode/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "time-decode";
  };
})
