{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

let
<<<<<<< HEAD
  version = "0.12.1";
=======
  version = "0.12.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
python3Packages.buildPythonApplication {
  pname = "whatsapp-chat-exporter";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KnugiHK";
    repo = "Whatsapp-Chat-Exporter";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-AyxRIjcAGjxCe0m2cSESQWd75v5tzpsCmb+3wChbH7c=";
=======
    hash = "sha256-0FJZqqmuSA+te5lzi1okkmuT3s2JNX7uHoYl9ayNt/Q=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
