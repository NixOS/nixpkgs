{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "termineter";
  version = "1.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rsmusllp";
    repo = "termineter";
    tag = "v${version}";
    hash = "sha256-sJN1FNUCpQUMJNM6F2+v0NmGqu4LVYcsffwzl3Hr1CU=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    crcelk
    pluginbase
    pyasn1
    pyserial
    smoke-zephyr
    tabulate
    termcolor
  ];

  pythonImportsCheck = [ "termineter" ];

  meta = {
    description = "Smart Meter Security Testing Framework";
    homepage = "https://github.com/rsmusllp/termineter";
    changelog = "https://github.com/rsmusllp/termineter/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "termineter";
  };
}
