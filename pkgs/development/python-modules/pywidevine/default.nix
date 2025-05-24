{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  poetry-core,

  # dependencies
  pyyaml,
  unidecode,
  click,
  protobuf4,
  pycryptodome,
  pymp4,
  requests,
}:
buildPythonPackage rec {
  pname = "pywidevine";
  version = "1.8.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wU8/4oZEc0FrnKpz2aISUaAtchOObVTYwaP0S3prBck=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    pyyaml
    unidecode
    click
    protobuf4
    pycryptodome
    pymp4
    requests
  ];

  meta = {
    description = "Python implementation of Google's Widevine DRM CDM";
    homepage = "https://github.com/devine-dl/pywidevine";
    changelog = "https://github.com/devine-dl/pywidevine/releases/tag/v${version}";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ valentinegb ];
  };
}
