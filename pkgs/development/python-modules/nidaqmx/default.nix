{
  lib,
  stdenv,
  buildPythonPackage,
  click,
  deprecation,
  distro,
  fetchFromGitHub,
  grpcio,
  hightime,
  numpy,
  poetry-core,
  protobuf,
  python-decouple,
  requests,
  sphinx-rtd-theme,
  sphinx,
  toml,
  tzlocal,
}:

buildPythonPackage rec {
  pname = "nidaqmx";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ni";
    repo = "nidaqmx-python";
    tag = version;
    hash = "sha256-uxf+1nmJ+YFS3zGu+0YP4zOdBlSCHPYC8euqZIGwb00=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    click
    deprecation
    hightime
    numpy
    python-decouple
    requests
    tzlocal
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    distro
  ];

  optional-dependencies = {
    docs = [
      sphinx
      sphinx-rtd-theme
      toml
    ];
    grpc = [
      grpcio
      protobuf
    ];
  };

  # Tests require hardware
  doCheck = false;

  pythonImportsCheck = [ "nidaqmx" ];

  meta = {
    changelog = "https://github.com/ni/nidaqmx-python/releases/tag/${src.tag}";
    description = "API for interacting with the NI-DAQmx driver";
    homepage = "https://github.com/ni/nidaqmx-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fsagbuya ];
  };
}
