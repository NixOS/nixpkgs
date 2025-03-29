{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  cmake,
  pkg-config,
  rustPlatform,

  # native dependencies
  cyrus_sasl,
  openssl,
  protobuf,

  # dependencies
  jsonpickle,

  # optional dependencies
  confluent-kafka,

  # test
  myst-docutils,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bytewax";
  version = "0.17.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bytewax";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-BecZvBJsaTHIhJhWM9GZldSL6Irrc7fiedulTN9e76I=";
  };

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  # Remove docs tests, myst-docutils in nixpkgs is not compatible with package requirements.
  # Package uses old version.
  patches = [ ./remove-docs-test.patch ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-osLr4u5vQa3/2whytC9PsXKURAwMCNObykY5Us7P3kQ=";
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

  propagatedBuildInputs = [ jsonpickle ];

  optional-dependencies = {
    kafka = [ confluent-kafka ];
  };

  preCheck = ''
    export PY_IGNORE_IMPORTMISMATCH=1
  '';

  checkInputs = [
    myst-docutils
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  disabledTestPaths = [
    # dependens on an old myst-docutils version
    "docs"
  ];

  pythonImportsCheck = [ "bytewax" ];

  meta = with lib; {
    description = "Python Stream Processing";
    homepage = "https://github.com/bytewax/bytewax";
    changelog = "https://github.com/bytewax/bytewax/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      mslingsby
      kfollesdal
    ];
    # mismatched type expected u8, found i8
    broken = stdenv.hostPlatform.isAarch64;
  };
}
