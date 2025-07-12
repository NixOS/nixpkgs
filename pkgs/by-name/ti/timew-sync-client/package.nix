{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "timew-sync-client";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "timewarrior-synchronize";
    repo = "timew-sync-client";
    rev = "v${version}";
    hash = "sha256-8Bw+BI7EiW9UcHo6gaDthX4VH4kAlycm4EvAJEEAOWc=";
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
