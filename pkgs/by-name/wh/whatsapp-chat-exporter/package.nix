{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

let
  version = "0.13.0";
in
python3Packages.buildPythonApplication {
  pname = "whatsapp-chat-exporter";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KnugiHK";
    repo = "Whatsapp-Chat-Exporter";
    tag = version;
    hash = "sha256-nD8rpA1BbKbHpjAuIDdhaiMUjQCypDuo0pNAYbkoOxo=";
  };

  propagatedBuildInputs = with python3Packages; [
    bleach
    javaobj-py3
    jinja2
    pycryptodome
    tqdm
  ];

  meta = {
    homepage = "https://github.com/KnugiHK/Whatsapp-Chat-Exporter";
    description = "WhatsApp database parser";
    changelog = "https://github.com/KnugiHK/Whatsapp-Chat-Exporter/releases/tag/${version}";
    longDescription = ''
      A customizable Android and iPhone WhatsApp database parser that will give
      you the history of your WhatsApp conversations inHTML and JSON. Android
      Backup Crypt12, Crypt14 and Crypt15 supported.
    '';
    license = lib.licenses.mit;
    mainProgram = "wtsexporter";
    maintainers = with lib.maintainers; [
      bbenno
      EstebanMacanek
    ];
  };
}
