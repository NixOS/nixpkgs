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
  nitypes,
  numpy,
  poetry-core,
  protobuf,
  python-decouple,
  requests,
  sphinx-rtd-theme,
  sphinx,
  toml,
  typing-extensions,
  tzlocal,
}:

buildPythonPackage rec {
  pname = "nidaqmx";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ni";
    repo = "nidaqmx-python";
    tag = version;
    hash = "sha256-jg/1vhLraM6lvdOcO45ocG4y3DqMappZ+EUxM/naeuA=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    click
    deprecation
    hightime
    nitypes
    numpy
    python-decouple
    requests
    typing-extensions
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
