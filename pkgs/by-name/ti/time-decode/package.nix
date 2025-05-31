{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "time-decode";
  version = "9.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "digitalsleuth";
    repo = "time_decode";
    tag = "v${version}";
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

  meta = with lib; {
    description = "Timestamp and date decoder";
    homepage = "https://github.com/digitalsleuth/time_decode";
    changelog = "https://github.com/digitalsleuth/time_decode/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "time-decode";
  };
}
