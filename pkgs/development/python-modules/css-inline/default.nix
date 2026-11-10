{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  rustPlatform,

  # native darwin dependencies
  libiconv,

  # tests
  pytestCheckHook,
  hypothesis,

  # updater
  cargo,
  common-updater-scripts,
  gitMinimal,
  nix-update,
  writeShellApplication,
}:

buildPythonPackage rec {
  pname = "css-inline";
  version = "0.23.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Stranger6667";
    repo = "css-inline";
    rev = "python-v${version}";
    hash = "sha256-X59hCKncYNBEKbbAzDR6r68C2OXtkTgkQ77G6Bqk/Y8=";
  };

  postPatch = ''
    cd crates/css-inline-python
    ln -s ${./Cargo.lock} Cargo.lock

    # don't rebuild std
    rm .cargo/config.toml
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    postPatch = ''
      cd crates/css-inline-python
      ln -s ${./Cargo.lock} Cargo.lock
    '';
    hash = "sha256-HCUgK0gqzfKKunjd+B0IwypocRoiuka+Xd/C1uhga7M=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  pythonImportsCheck = [ "css_inline" ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  disabledTests = [
    # fails to connect to local server
    "test_cache"
    "test_remote_stylesheet"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
    # pyo3_runtime.PanicException: event loop thread panicked
    "test_invalid_href"
  ];

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "css-inline-updater";
    runtimeInputs = [
      cargo
      common-updater-scripts
      gitMinimal
      nix-update
    ];
    text = ''
      TAG="$(list-git-tags --url=https://github.com/Stranger6667/css-inline | \
        grep "^python" | \
        sort --version-sort | \
        tail --lines 1)"
      VERSION="''${TAG//python-v/}"
      REPO_ROOT="$(git rev-parse --show-toplevel)"
      PKG_DIR="$REPO_ROOT/pkgs/development/python-modules/css-inline"

      (
        cd "$(mktemp -d)"
        git clone "${src.gitRepoUrl}" .
        git checkout "$TAG"
        pushd crates/css-inline-python
        rm -rf .cargo # unstable build std
        cargo generate-lockfile --manifest-path ./Cargo.toml
        popd
        cp Cargo.lock "$PKG_DIR/"
      )

      nix-update --version="$VERSION" python3Packages.css-inline
    '';
  });

  meta = {
    description = "Inline CSS into style attributes";
    homepage = "https://github.com/Stranger6667/css-inline";
    changelog = "https://github.com/Stranger6667/css-inline/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
