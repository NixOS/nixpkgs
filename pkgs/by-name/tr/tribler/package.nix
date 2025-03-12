{
  lib,
  stdenv,
  python312,
  makeWrapper,
  nix-update-script,
  fetchFromGitHub,
  rustPlatform,
  buildNpmPackage,
  nodejs_20,
}:
let
  version = "8.1.0";
  python3 = python312;
  nodejs = nodejs_20;

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "tribler";
    repo = "tribler";
    hash = "sha256-hQ9O/ZqE7ZTduaFfdvS3szaJGwrv0Ch/HlcwMW23PPM=";
  };

  ipv8-rust-tunnels = python3.pkgs.buildPythonPackage rec {
    pname = "ipv8-rust-tunnels";
    version = "0.1.29";

    src = fetchFromGitHub {
      owner = "tribler";
      repo = "ipv8-rust-tunnels";
      rev = version;
      hash = "sha256-xscMTcdYID15/8zRv7X9AFqUfFT3PtC1V8+KTs9dXrE=";
    };

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit pname version src;
      hash = "sha256-niVOOBsSomMNg2XubfVJbORO+lOWE2VQp3if11ve6yY=";
      postPatch = ''
        ln -s ${./ipv8-rust-tunnels/Cargo.lock} Cargo.lock
      '';
    };

    postPatch = ''
      ln -s ${./ipv8-rust-tunnels/Cargo.lock} Cargo.lock
    '';

    format = "pyproject";

    nativeBuildInputs = with rustPlatform; [
      cargoSetupHook
      maturinBuildHook
    ];
  };

  tribler-webui = buildNpmPackage {
    inherit nodejs version;
    pname = "tribler-webui";
    src = "${src}/src/tribler/ui";
    npmDepsHash = "sha256-QnVJ9oBaQN3XQOiQU7lIWKL5bXSSKnCe0orvuG/qPYs=";

    # The prepack script runs the build script, which we'd rather do in the build phase.
    npmPackFlags = [ "--ignore-scripts" ];

    NODE_OPTIONS = "--openssl-legacy-provider";

    dontNpmBuild = true;
    dontNpmInstall = true;

    installPhase = ''
      mkdir -pv $out
      cp -prvd ./* $out/
      cd $out
      npm install
      npm run build
    '';
  };
in
python3.pkgs.buildPythonApplication {
  inherit version src;
  pname = "tribler";
  pyproject = true;

  build-system = with python3.pkgs; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3.pkgs; [
    # requirements.txt
    bitarray
    configobj
    lz4
    libtorrent-rasterbar
    pillow
    pony
    pystray
    pyipv8
    ipv8-rust-tunnels
  ];

  configurePhase = ''
    ln -s ${./pyproject.toml} pyproject.toml
    ln -s ${./__main__.py} src/tribler/__main__.py

    rm -r src/tribler/ui
    ln -s ${tribler-webui} src/tribler/ui
  '';

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = with python3.pkgs; [
    sphinxHook
    astroid
    sphinx-autoapi
    sphinx-rtd-theme
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  disabledTests = [
    "test_establish_connection"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Decentralised P2P filesharing client based on the Bittorrent protocol";
    mainProgram = "tribler";
    homepage = "https://www.tribler.org/";
    changelog = "https://github.com/Tribler/tribler/releases/tag/v${version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      mkg20001
      mlaradji
      xvapx
    ];
    platforms = lib.platforms.linux;
  };
}
