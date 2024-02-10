{ lib
, buildPythonPackage
, fetchPypi
, cargo
, pkg-config
, protobuf
, rustPlatform
, rustc
, zeromq
, quil
, stdenv
, darwin
}:

buildPythonPackage rec {
  pname = "qcs-sdk-python";
  version = "0.16.4";
  pyproject = true;

  src = fetchPypi {
    pname = "qcs_sdk_python";
    inherit version;
    hash = "sha256-ljPdUKOE1IT8yZLP3rEBti0VviWN6xpql/ATaognhhY=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "quil-rs-0.22.6" = "sha256-okaviveJHcltDBo3cOY/eDuCzUYB+EDe2UjNwtLoaMo=";
    };
  };

  nativeBuildInputs = [
    cargo
    pkg-config
    protobuf
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  buildInputs = [
    zeromq
    quil
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Python interface for the QCS Rust SDK";
    homepage = "https://pypi.org/project/qcs-sdk-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ocfox ];
  };
}
