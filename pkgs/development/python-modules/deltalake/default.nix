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
, pandas
, azure-storage-blob
}:

buildPythonPackage rec {
  pname = "deltalake";
  version = "0.18.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xvmtaHNkE6bXwVJtYJBc30qutZuMlcx4JmElCRdxmu8=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-/2K8/hsMIeidfviCKK+ffWPB51svWZa+9eZoK9erBaY=";
  };

  env.OPENSSL_NO_VENDOR = 1;

  dependencies = [
    pyarrow
    pyarrow-hotfix
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
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
