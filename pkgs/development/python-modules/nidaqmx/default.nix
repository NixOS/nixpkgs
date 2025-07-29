{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pythonOlder,
  numpy,
  deprecation,
  hightime,
  tzlocal,
  python-decouple,
  click,
  distro,
  requests,
  sphinx,
  sphinx-rtd-theme,
  grpcio,
  protobuf,
  toml,
}:

buildPythonPackage rec {
  pname = "nidaqmx";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ni";
    repo = "nidaqmx-python";
    tag = version;
    hash = "sha256-WNr+zVrA4X2AjizsmMEau54Vv1Svey3LNsCo8Bm/W+A=";
  };

  disabled = pythonOlder "3.8";

  build-system = [ poetry-core ];

  prePatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'poetry.masonry.api' 'poetry.core.masonry.api'

    substituteInPlace pyproject.toml \
      --replace-fail '["poetry>=1.2"]' '["poetry-core>=1.0.0"]'
  '';

  dependencies = [
    numpy
    deprecation
    hightime
    tzlocal
    python-decouple
    click
    requests
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    distro
  ];

  passthru.optional-dependencies = {
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
