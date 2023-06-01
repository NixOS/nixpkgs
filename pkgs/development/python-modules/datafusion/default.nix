{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
, rustPlatform
, pytestCheckHook
, libiconv
, numpy
, protobuf
, pyarrow
, Security
}:

let
  arrow-testing = fetchFromGitHub {
    name = "arrow-testing";
    owner = "apache";
    repo = "arrow-testing";
    rev = "47f7b56b25683202c1fd957668e13f2abafc0f12";
    hash = "sha256-ZDznR+yi0hm5O1s9as8zq5nh1QxJ8kXCRwbNQlzXpnI=";
  };

  parquet-testing = fetchFromGitHub {
    name = "parquet-testing";
    owner = "apache";
    repo = "parquet-testing";
    rev = "b2e7cc755159196e3a068c8594f7acbaecfdaaac";
    hash = "sha256-IFvGTOkaRSNgZOj8DziRj88yH5JRF+wgSDZ5N0GNvjk=";
  };
in

buildPythonPackage rec {
  pname = "datafusion";
  version = "23.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    name = "datafusion-source";
    owner = "apache";
    repo = "arrow-datafusion-python";
    rev = "refs/tags/${version}";
    hash = "sha256-ndee7aNmoTtZyfl9UUXdNVHkp0GAuJWkyfZJyRrGwn8=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    name = "datafusion-cargo-deps";
    inherit src pname version;
    hash = "sha256-eDweEc+7dDbF0WBi6M5XAPIiHRjlYAdf2eNJdwj4D7c=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = [ protobuf ] ++ lib.optionals stdenv.isDarwin [ libiconv Security ];

  propagatedBuildInputs = [ pyarrow ];

  nativeCheckInputs = [ pytestCheckHook numpy ];
  pythonImportsCheck = [ "datafusion" ];
  pytestFlagsArray = [ "--pyargs" pname ];

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
