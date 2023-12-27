{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "termineter";
  version = "1.0.4";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "rsmusllp";
    repo = "termineter";
    rev = "v${version}";
    hash = "sha256-WZG5njKZxlhokRvghphH458e4b3i+ZWCn6zYtBGjvyM=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    crcelk
    pluginbase
    pyasn1
    pyserial
    smoke-zephyr
    tabulate
    termcolor
    setuptools
  ];

  meta = with lib; {
    description = "Smart Meter Security Testing Framework";
    homepage = "https://github.com/rsmusllp/termineter";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ t4ccer ];
    mainProgram = "termineter";
  };
}
