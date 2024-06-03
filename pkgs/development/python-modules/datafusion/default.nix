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
  pyarrow,
  Security,
  SystemConfiguration,
}:

let
  arrow-testing = fetchFromGitHub {
    name = "arrow-testing";
    owner = "apache";
    repo = "arrow-testing";
    rev = "5bab2f264a23f5af68f69ea93d24ef1e8e77fc88";
    hash = "sha256-Pxx8ohUpXb5u1995IvXmxQMqWiDJ+7LAll/AjQP7ph8=";
  };

  parquet-testing = fetchFromGitHub {
    name = "parquet-testing";
    owner = "apache";
    repo = "parquet-testing";
    rev = "e13af117de7c4f0a4d9908ae3827b3ab119868f3";
    hash = "sha256-rVI9zyk9IRDlKv4u8BeMb0HRdWLfCpqOlYCeUdA7BB8=";
  };
in

buildPythonPackage rec {
  pname = "datafusion";
  version = "35.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    name = "datafusion-source";
    owner = "apache";
    repo = "arrow-datafusion-python";
    rev = "refs/tags/${version}";
    hash = "sha256-43XY7j/8x+7SCY4W8nysaeWax2nvTTHZXMmy3hSz6pI=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    name = "datafusion-cargo-deps";
    inherit src pname version;
    hash = "sha256-YWAyEMojw0bc/fu5kIZKMNPEgsAIpWqjVNodWXbgTl4=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs =
    [ protobuf ]
    ++ lib.optionals stdenv.isDarwin [
      libiconv
      Security
      SystemConfiguration
    ];

  propagatedBuildInputs = [ pyarrow ];

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
