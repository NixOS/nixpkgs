{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytestCheckHook,
  libiconv,
  numpy,
  protobuf,
  protoc,
  pyarrow,
  Security,
  SystemConfiguration,
  typing-extensions,
  pythonOlder,
}:

let
  arrow-testing = fetchFromGitHub {
    name = "arrow-testing";
    owner = "apache";
    repo = "arrow-testing";
    rev = "4d209492d514c2d3cb2d392681b9aa00e6d8da1c";
    hash = "sha256-IkiCbuy0bWyClPZ4ZEdkEP7jFYLhM7RCuNLd6Lazd4o=";
  };

  parquet-testing = fetchFromGitHub {
    name = "parquet-testing";
    owner = "apache";
    repo = "parquet-testing";
    rev = "50af3d8ce206990d81014b1862e5ce7380dc3e08";
    hash = "sha256-edyv/r5olkj09aHtm8LHZY0b3jUtLNUcufwI41qKYaY=";
  };
in

buildPythonPackage rec {
  pname = "datafusion";
  version = "40.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    name = "datafusion-source";
    owner = "apache";
    repo = "arrow-datafusion-python";
    rev = "refs/tags/${version}";
    hash = "sha256-5WOSlx4XW9zO6oTY16lWQElShLv0ubflVPfSSEGrFgg=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    name = "datafusion-cargo-deps";
    inherit src;
    hash = "sha256-hN03tbnH77VsMDxSMddMHIH00t7lUs5h8rTHbiMIExw=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
    protoc
  ];

  buildInputs =
    [ protobuf ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
      Security
      SystemConfiguration
    ];

  dependencies = [
    pyarrow
  ] ++ lib.optionals (pythonOlder "3.13") [ typing-extensions ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
  ];

  pythonImportsCheck = [ "datafusion" ];

  pytestFlagsArray = [
    "--pyargs"
    pname
  ];

  preCheck = ''
    pushd $TMPDIR
    ln -s ${arrow-testing} ./testing
    ln -s ${parquet-testing} ./parquet
  '';

  postCheck = ''
    popd
  '';

  meta = with lib; {
    description = "Extensible query execution framework";
    longDescription = ''
      DataFusion is an extensible query execution framework, written in Rust,
      that uses Apache Arrow as its in-memory format.
    '';
    homepage = "https://arrow.apache.org/datafusion/";
    changelog = "https://github.com/apache/arrow-datafusion-python/blob/${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ cpcloud ];
  };
}
