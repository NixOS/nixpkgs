{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

let
  version = "0.13.1";
in
python3Packages.buildPythonApplication {
  pname = "whatsapp-chat-exporter";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KnugiHK";
    repo = "Whatsapp-Chat-Exporter";
    tag = version;
    hash = "sha256-XRDvXYV4RWSjFkVW1JEA2JkwddgJP1ZE+RgB/WP7PLM=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    bleach
    javaobj-py3
    jinja2
    pycryptodome
    tqdm
  ];

  passthru.updateScript = nix-update-script { };

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
    ];
  };
}
