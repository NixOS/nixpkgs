{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

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
  prometheus-client,

  # optional dependencies
  confluent-kafka,

  # test
  myst-docutils,
  pytestCheckHook,
  pytest-benchmark,
}:

buildPythonPackage rec {
  pname = "bytewax";
  version = "0.21.1";
  pyproject = true;

  # error: the configured Python interpreter version (3.13) is newer than PyO3's maximum supported version (3.12)
  disabled = pythonAtLeast "3.13";

  src = fetchFromGitHub {
    owner = "bytewax";
    repo = "bytewax";
    tag = "v${version}";
    hash = "sha256-O5q1Jd3AMUaQwfQM249CUnkjqEkXybxtM9SOISoULZk=";
  };

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-TTB1//Xza47rnfvlIs9qMvwHPj/U3w2cGTmWrEokriQ=";
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

  dependencies = [
    jsonpickle
    prometheus-client
  ];

  optional-dependencies = {
    kafka = [ confluent-kafka ];
  };

  preCheck = ''
    export PY_IGNORE_IMPORTMISMATCH=1
  '';

  nativeCheckInputs = [
    myst-docutils
    pytestCheckHook
    pytest-benchmark
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pytestFlags = [
    "--benchmark-disable"
  ];

  enabledTestPaths = [
    "pytests"
  ];

  disabledTestPaths = [
    # dependens on an old myst-docutils version
    "docs"
  ];

  pythonImportsCheck = [ "bytewax" ];

  meta = {
    description = "Python Stream Processing";
    homepage = "https://github.com/bytewax/bytewax";
    changelog = "https://github.com/bytewax/bytewax/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mslingsby
      kfollesdal
    ];
  };
}
