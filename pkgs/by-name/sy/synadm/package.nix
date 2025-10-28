{
  lib,
  python3Packages,
  fetchFromGitea,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "synadm";
  version = "0.49.2";
  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "synadm";
    repo = "synadm";
    tag = "v${version}";
    hash = "sha256-Nh4pzOXBXwbhq49Hq8vmPi6AS6N/tRqDBjIVKH3Gh6s=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    click
    click-option-group
    dnspython
    tabulate
    pyyaml
    requests
    requests-unixsocket
  ];

  checkPhase = ''
    runHook preCheck
    export HOME=$TMPDIR
    $out/bin/synadm -h > /dev/null
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Command line admin tool for Synapse";
    mainProgram = "synadm";
    longDescription = ''
      A CLI tool to help admins of Matrix Synapse homeservers
      conveniently issue commands available via its admin API's
      (element-hq/synapse@master/docs/admin_api)
    '';
    changelog = "https://codeberg.org/synadm/synadm/releases/tag/${src.tag}";
    downloadPage = "https://codeberg.org/synadm/synadm";
    homepage = "https://synadm.readthedocs.io/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hexa ];
  };
}
