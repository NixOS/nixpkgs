{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "whatsapp-chat-exporter";
  version = "0.10.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "KnugiHK";
    repo = "Whatsapp-Chat-Exporter";
    rev = "refs/tags/${version}";
    hash = "sha256-W66qEQa7jlgd8v6dsIVAz6gmWsYr3SMqyhF2KIwC6hI=";
  };

  propagatedBuildInputs = with python3Packages; [
    bleach
    jinja2
    pycryptodome
    javaobj-py3
  ];

  meta = with lib; {
    homepage = "https://github.com/KnugiHK/Whatsapp-Chat-Exporter";
    description = "WhatsApp database parser";
    changelog = "https://github.com/KnugiHK/Whatsapp-Chat-Exporter/releases/tag/${version}";
    longDescription = ''
      A customizable Android and iPhone WhatsApp database parser that will give
      you the history of your WhatsApp conversations inHTML and JSON. Android
      Backup Crypt12, Crypt14 and Crypt15 supported.
    '';
    license = licenses.mit;
    mainProgram = "wtsexporter";
    maintainers = with maintainers; [ bbenno ];
  };
}
