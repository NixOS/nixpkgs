{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

let
  version = "0.12.0";
in
python3Packages.buildPythonApplication {
  pname = "whatsapp-chat-exporter";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KnugiHK";
    repo = "Whatsapp-Chat-Exporter";
    tag = version;
    hash = "sha256-0FJZqqmuSA+te5lzi1okkmuT3s2JNX7uHoYl9ayNt/Q=";
  };

  propagatedBuildInputs = with python3Packages; [
    bleach
    jinja2
    pycryptodome
    javaobj-py3
    vobject
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
