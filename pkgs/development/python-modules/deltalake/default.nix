{ lib
, buildPythonPackage
, fetchPypi
, rustPlatform
, pyarrow
, pyarrow-hotfix
, openssl
, stdenv
, darwin
, libiconv
, pkg-config
, pytestCheckHook
, pytest-benchmark
, pytest-cov
, pytest-mock
, pandas
, azure-storage-blob
}:

buildPythonPackage rec {
  pname = "deltalake";
  version = "0.19.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Xgn6uyIfuB6YnCg8FieOr/tuhXBtmDZKvNpcDGynNZg=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-ebX51/ztIdhY81sd0fdPsKvaGtCEk8oofrj/Nrt8nfA=";
  };

  env.OPENSSL_NO_VENDOR = 1;

  dependencies = [
    pyarrow
    pyarrow-hotfix
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
    libiconv
  ];

  nativeBuildInputs = [
    pkg-config # openssl-sys needs this
  ] ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);

  pythonImportsCheck = [ "deltalake" ];

  nativeCheckInputs = [
    pytestCheckHook
    pandas
    pytest-benchmark
    pytest-cov
    pytest-mock
    azure-storage-blob
  ];

  preCheck = ''
    # For paths in test to work, we have to be in python dir
    cp pyproject.toml python/
    cd python

    # In tests we want to use deltalake that we have built
    rm -rf deltalake
  '';

  pytestFlagsArray = [ "-m 'not integration'" ];

  meta = with lib; {
    description = "Native Rust library for Delta Lake, with bindings into Python";
    homepage = "https://github.com/delta-io/delta-rs";
    changelog = "https://github.com/delta-io/delta-rs/blob/python-v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ kfollesdal mslingsby harvidsen andershus ];
  };
}
