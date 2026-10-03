{
  lib,
  python3Packages,
  fetchFromGitHub,
  unstableGitUpdater,
  python3,
  talosctl,
  kubernetes-helm,
  fluxcd,
  kubectl,
}:

python3Packages.buildPythonApplication {
  pname = "talos-bootstrap";
  version = "0-unstable-2026-02-26";

  pyproject = true;
  build-system = [ python3.pkgs.setuptools ];

  src = fetchFromGitHub {
    owner = "twelho";
    repo = "talos-bootstrap";
    rev = "9c828e440c99e571cfe5885df5279d47f41494a1";
    hash = "sha256-wxQgy2eTor0B+lN3mTT/r4bAKSxmIlyxa0iqqgyLI6Y=";
  };

  dependencies =
    with python3.pkgs;
    [
      python-gnupg
      pyyaml
      requests
      schema
    ]
    ++ [
      talosctl
      kubernetes-helm
      fluxcd
      kubectl
    ];

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "Bootstrap a provisioned Talos Linux cluster";
    homepage = "https://github.com/twelho/talos-bootstrap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mkez ];
    mainProgram = "bootstrap";
  };
}
