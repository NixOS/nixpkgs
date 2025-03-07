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
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ni";
    repo = "nidaqmx-python";
    rev = "${version}";
    hash = "sha256-rf5cGq3Iv6ucURSUFuFANQzaGeufBZ+adjKlg4B5DRY=";
  };

  disabled = pythonOlder "3.8";

  build-system = [ poetry-core ];

  prePatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'poetry.masonry.api' 'poetry.core.masonry.api'

    substituteInPlace pyproject.toml \
      --replace-fail '["poetry>=1.2"]' '["poetry-core>=1.0.0"]'
  '';

  dependencies =
    [
      numpy
      deprecation
      hightime
      tzlocal
      python-decouple
      click
      requests
    ]
    ++ lib.optionals stdenv.isLinux [
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
    changelog = "https://github.com/ni/nidaqmx-python/releases/tag/v${version}";
    description = "API for interacting with the NI-DAQmx driver";
    homepage = "https://github.com/ni/nidaqmx-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fsagbuya ];
  };
}
