{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchPypi,
  installShellFiles,
  pythonOlder,
  setuptools-scm,
  writeScript,
}:

buildPythonPackage rec {
  pname = "git-filter-repo";
  version = "2.47.0";
  docs_version = "71d71d4be238628bf9cb9b27be79b8bb824ed1a9";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "git_filter_repo";
    inherit version;
    hash = "sha256-QRsn5ooIDAemnCM8tSbbwthIsJpy8QR39ERN0IIs8pA=";
  };

  docs = fetchFromGitHub {
    owner = "newren";
    repo = "git-filter-repo";
    rev = docs_version;
    hash = "sha256-m9NI7bLR5F+G7f3Dyi4sP6n4qz2i8cdBRuIn0OcpHAw=";
  };

  postInstall = ''
    installManPage ${docs}/man1/git-filter-repo.1
  '';

  build-system = [ setuptools-scm ];

  nativeBuildInputs = [ installShellFiles ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "git_filter_repo" ];

  meta = with lib; {
    description = "Quickly rewrite git repository history";
    homepage = "https://github.com/newren/git-filter-repo";
    changelog = "https://github.com/newren/git-filter-repo/releases/tag/v${version}";
    license = with licenses; [
      mit # or
      gpl2Plus
    ];
    maintainers = with maintainers; [
      aiotter
      fab
    ];
    mainProgram = "git-filter-repo";
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
