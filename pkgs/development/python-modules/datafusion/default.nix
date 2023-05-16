{ lib
, stdenv
, buildPythonPackage
<<<<<<< HEAD
=======
, fetchPypi
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    rev = "5bab2f264a23f5af68f69ea93d24ef1e8e77fc88";
    hash = "sha256-Pxx8ohUpXb5u1995IvXmxQMqWiDJ+7LAll/AjQP7ph8=";
=======
    rev = "47f7b56b25683202c1fd957668e13f2abafc0f12";
    hash = "sha256-ZDznR+yi0hm5O1s9as8zq5nh1QxJ8kXCRwbNQlzXpnI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  parquet-testing = fetchFromGitHub {
    name = "parquet-testing";
    owner = "apache";
    repo = "parquet-testing";
<<<<<<< HEAD
    rev = "e13af117de7c4f0a4d9908ae3827b3ab119868f3";
    hash = "sha256-rVI9zyk9IRDlKv4u8BeMb0HRdWLfCpqOlYCeUdA7BB8=";
=======
    rev = "b2e7cc755159196e3a068c8594f7acbaecfdaaac";
    hash = "sha256-IFvGTOkaRSNgZOj8DziRj88yH5JRF+wgSDZ5N0GNvjk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
in

buildPythonPackage rec {
  pname = "datafusion";
<<<<<<< HEAD
  version = "25.0.0";
=======
  version = "23.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    name = "datafusion-source";
    owner = "apache";
    repo = "arrow-datafusion-python";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-oC+fp41a9rsdobpvShZ7sDdtYPJQQ7JLg6MFL+4Pksg=";
=======
    hash = "sha256-ndee7aNmoTtZyfl9UUXdNVHkp0GAuJWkyfZJyRrGwn8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    name = "datafusion-cargo-deps";
    inherit src pname version;
<<<<<<< HEAD
    hash = "sha256-0e0ZRgwcS/46mi4c2loAnBA2bsaD+/RiMh7oNg3EvHY=";
=======
    hash = "sha256-eDweEc+7dDbF0WBi6M5XAPIiHRjlYAdf2eNJdwj4D7c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
