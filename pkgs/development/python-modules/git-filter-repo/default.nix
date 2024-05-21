{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchPypi
, fetchpatch
, installShellFiles
, pythonOlder
, setuptools-scm
, writeScript
}:

buildPythonPackage rec {
  pname = "git-filter-repo";
  version = "2.38.0";
  docs_version = "01ead411966a83dfcfb35f9d2e8a9f7f215eaa65";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/hdT4Y8L1tPJtXhoyAEa59BWpuurcGcGOWoV71MScl4=";
  };

  docs = fetchFromGitHub {
    owner = "newren";
    repo = "git-filter-repo";
    rev = docs_version;
    hash = "sha256-Z/3w3Rguo8sfuc/OQ25eFbMfiOHjxQqPY6S32zuvoY4=";
  };

  patches = [
    # https://github.com/newren/git-filter-repo/pull/498
    (fetchpatch {
      name = "remove-duplicate-script.patch";
      url = "https://github.com/newren/git-filter-repo/commit/a59e67e7918e577147ca36a70916741be029c878.patch";
      hash = "sha256-b0QHy9wMWuBWQoptdvLRT+9SRx2u2+11PnzEEB5F0Yo=";
      stripLen = 1;
    })
  ];

  postInstall = ''
    installManPage ${docs}/man1/git-filter-repo.1
  '';

  nativeBuildInputs = [
    setuptools-scm
    installShellFiles
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "git_filter_repo"
  ];

  meta = with lib; {
    description = "Quickly rewrite git repository history";
    mainProgram = "git-filter-repo";
    homepage = "https://github.com/newren/git-filter-repo";
    license = with licenses; [ mit /* or */ gpl2Plus ];
    maintainers = with maintainers; [ aiotter fab ];
  };

  passthru.updateScript = writeScript "update-${pname}" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p common-updater-scripts curl jq nix-update

    set -eu -o pipefail

    # Update program
    nix-update ${pname}

    # Update docs
    docs_latest=$(curl -s https://api.github.com/repos/newren/git-filter-repo/commits/heads/docs/status | jq -r '.sha')
    [[ "${docs_version}" = "$docs_latest" ]] || update-source-version ${pname} "$docs_latest" --version-key=docs_version --source-key=docs
  '';
}
