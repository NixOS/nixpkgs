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
}:

buildPythonPackage rec {
  pname = "pylance";
  version = "0.16.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lancedb";
    repo = "lance";
    rev = "refs/tags/v${version}";
    hash = "sha256-y9mDECGwXycrZTBuJVsBzTg2Tup3xd58FKruywP98gU=";
  };

  sourceRoot = "${src.name}/python";

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

  passthru.optional-dependencies = {
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
  ] ++ passthru.optional-dependencies.torch;

  preCheck = ''
    cd python/tests
  '';

  disabledTests = [
    # Error during planning: Invalid function 'invert'.
    "test_polar_scan"
    "test_simple_predicates"
  ];

  meta = {
    description = "Python wrapper for Lance columnar format";
    homepage = "https://github.com/lancedb/lance";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
