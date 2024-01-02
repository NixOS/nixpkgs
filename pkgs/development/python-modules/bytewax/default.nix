{ lib
, stdenv
, buildPythonPackage
, cmake
, confluent-kafka
, cyrus_sasl
, fetchFromGitHub
, openssl
, pkg-config
, protobuf
, pytestCheckHook
, pythonOlder
, rustPlatform
, setuptools-rust
}:

buildPythonPackage rec {
  pname = "bytewax";
  version = "0.17.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bytewax";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Cv2bTgs3XfYOcHK628/RgGol7S6E4WfHb7gHXXjBhig=";
  };

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  # Remove docs tests, myst-docutils in nixpkgs is not compatible with package requirements.
  # Package uses old version.
  patches = [ ./remove-docs-test.patch ];

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "columnation-0.1.0" = "sha256-RAyZKR+sRmeWGh7QYPZnJgX9AtWqmca85HcABEFUgX8=";
      "timely-0.12.0" = "sha256-sZuVLBDCXurIe38m4UAjEuFeh73VQ5Jawy+sr3U/HbI=";
    };
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    rustPlatform.maturinBuildHook
    rustPlatform.cargoSetupHook
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    openssl
    cyrus_sasl
    protobuf
  ];

  passthru.optional-dependencies = {
    kafka = [
      confluent-kafka
    ];
  };

  preCheck = ''
    export PY_IGNORE_IMPORTMISMATCH=1
  '';

  checkInputs = [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "bytewax"
  ];

  meta = with lib; {
    description = "Python Stream Processing";
    homepage = "https://github.com/bytewax/bytewax";
    changelog = "https://github.com/bytewax/bytewax/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ mslingsby kfollesdal ];
    # mismatched type expected u8, found i8
    broken = stdenv.isAarch64;
  };
}
