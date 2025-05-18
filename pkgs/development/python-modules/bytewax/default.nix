{
  lib,
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
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bytewax";
    repo = pname;
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
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pytestFlagsArray = [
    "--benchmark-disable"
    "pytests"
  ];

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
  };
}
