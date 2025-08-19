{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  grpcio-tools,
  attrs,
  absl-py,
  numpy,
  protobuf,
  portpicker,
  grpcio,
  googleapis-common-protos,
  sqlalchemy,
  pytestCheckHook,
}:

let
  googleapis = fetchFromGitHub {
    owner = "googleapis";
    repo = "googleapis";
    rev = "master";
    hash = "sha256-cvOzmCCmYnI7EqIAqtB1q9DdYkTqReBOe2GGnsf7PsQ=";
  };
in
buildPythonPackage rec {
  pname = "google-vizier";
  version = "0.1.24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "vizier";
    rev = "v${version}";
    hash = "sha256-VXlv+XftlftQQNS2pkee6X3NRw0vsQZtpWIM3Rg0Mdk=";
  };

  postPatch = ''
    # Patch build_protos.sh to not download googleapis
    substituteInPlace build_protos.sh \
      --replace-fail 'wget https://github.com/googleapis/googleapis/archive/master.tar.gz' 'echo "Skipping download"' \
      --replace-fail 'tar xzf master.tar.gz' 'echo "Skipping extract"' \
      --replace-fail 'cp -r googleapis-master/google' 'cp -r ${googleapis}/google'
  '';

  build-system = [
    setuptools
    grpcio-tools
  ];

  dependencies = [
    attrs
    absl-py
    numpy
    protobuf
    portpicker
    grpcio
    googleapis-common-protos
    sqlalchemy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Many tests require additional optional dependencies (jax, tensorflow, pyglove, ray, equinox, etc)
  # Disable tests that need those for now
  disabledTestPaths = [
    "vizier/_src/algorithms"
    "vizier/_src/benchmarks"
    "vizier/_src/jax"
    "vizier/_src/pyglove"
    "vizier/_src/pythia"
    "vizier/_src/raytune"
    "vizier/_src/service" # Service tests require JAX
    "vizier/pyvizier/converters"
    "vizier/utils/profiler_test.py" # Requires equinox
  ];

  pythonImportsCheck = [
    "vizier"
  ];

  meta = {
    description = "Distributed service framework for blackbox optimization";
    homepage = "https://github.com/google/vizier";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ siraben ];
  };
}
