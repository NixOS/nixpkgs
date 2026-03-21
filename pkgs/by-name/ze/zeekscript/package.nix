{
  lib,
  python3,
  fetchFromGitHub,
  writeScript,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "zeekscript";
  version = "1.3.2-75";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zeek";
    repo = "zeekscript";
    rev = "74591d35d6e9fbb805d2af738032c05b31d3c93a";
    hash = "sha256-VAcbrzRIKdPC3q7U+ze7d3lVwDessHVL9orNYKzLovs=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    argcomplete
    tree-sitter
    tree-sitter-zeek
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    pytest-cov-stub
  ];

  checkInputs = with python3.pkgs; [ syrupy ];

  pythonImportsCheck = [
    "zeekscript"
  ];

  passthru.updateScript = writeScript "update-${pname}" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p git common-updater-scripts
    tmpdir="$(mktemp -d)"
    git clone "${src.gitRepoUrl}" "$tmpdir"
    pushd "$tmpdir"
    newVersion=$(cat VERSION)
    newRevision=$(git log -s -n 1 --pretty='format:%H' VERSION)
    popd
    rm -rf "$tmpdir"
    update-source-version "${pname}" "$newVersion" --rev="$newRevision"
  '';

  meta = {
    description = "Zeek script formatter and analyzer";
    homepage = "https://github.com/zeek/zeekscript";
    changelog = "https://github.com/zeek/zeekscript/blob/${src.rev}/CHANGES";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      fab
      tobim
      mdaniels5757
    ];
  };
}
