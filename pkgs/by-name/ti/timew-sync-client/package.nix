{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "timew-sync-client";
  version = "1.0.1-unstable-2024-08-05";

  src = fetchFromGitHub {
    owner = "timewarrior-synchronize";
    repo = "timew-sync-client";
    rev = "de3442bd29b071f54cd1e10af99f3378a83b4794";
    hash = "sha256-AKRAMEUTIPvR+kaEZZYjd4II2KzYZTwRgGzFMGD5aio=";
  };

  pyproject = true;

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    requests
    jwcrypto
    pyjwt
    colorama
  ];

  meta = {
    description = "Client component of timewarrior synchronization application";
    mainProgram = "timew-sync-client";
    homepage = "https://github.com/timewarrior-synchronize/timew-sync-client";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      evris99
      errnoh
    ];
  };
}
