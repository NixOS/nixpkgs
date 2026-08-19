{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "time-decode";
  version = "9.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "digitalsleuth";
    repo = "time_decode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kydH5WN2PELq6YnoSBFRsyVnxL+0r09WxXuqFANXuNs=";
  };

  nativeBuildInputs = with python3.pkgs; [ setuptools ];

  propagatedBuildInputs = with python3.pkgs; [
    colorama
    juliandate
    pyqt6
    python-dateutil
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
