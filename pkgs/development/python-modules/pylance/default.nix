{
  lib,
  stdenv,
  buildPythonPackage,
  rustPlatform,
  fetchFromGitHub,
  darwin,
  libiconv,
  pkg-config,
  protobuf,
  numpy,
  pyarrow,
  ml-dtypes,
  pandas,
  pillow,
  polars,
  pytestCheckHook,
  torch,
  tqdm,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "pylance";
  version = "0.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lancedb";
    repo = "lance";
    rev = "refs/tags/v${version}";
    hash = "sha256-bB+6q3kkSxY8i5xf4wumREHizUGWWOZ8Tr5Gt10CVAs=";
  };

  buildAndTestSubdir = "python";

  cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    pkg-config
    rustPlatform.cargoSetupHook
  ];

  build-system = [ rustPlatform.maturinBuildHook ];

  buildInputs =
    [
      libiconv
      protobuf
    ]
    ++ lib.optionals stdenv.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Security
        SystemConfiguration
      ]
    );

  pythonRelaxDeps = [ "pyarrow" ];

  dependencies = [
    numpy
    pyarrow
  ];

  optional-dependencies = {
    torch = [ torch ];
  };

  pythonImportsCheck = [ "lance" ];

  nativeCheckInputs = [
    ml-dtypes
    pandas
    pillow
    polars
    pytestCheckHook
    tqdm
  ] ++ optional-dependencies.torch;

  preCheck = ''
    cd python/python/tests
  '';

  disabledTests = [
    # Error during planning: Invalid function 'invert'.
    "test_polar_scan"
    "test_simple_predicates"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--generate-lockfile"
      "--lockfile-metadata-path"
      "python"
    ];
  };

  meta = {
    description = "Python wrapper for Lance columnar format";
    homepage = "https://github.com/lancedb/lance";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
