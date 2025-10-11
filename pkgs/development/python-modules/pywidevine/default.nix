{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pycryptodome,
  protobuf,
  requests,
  pyyaml,
  unidecode,
  click,
  pymp4,
  construct,
}:

buildPythonPackage {
  pname = "pywidevine";
  version = "1.8.0";
  pyproject = true;

  src = fetchPypi {
    pname = "pywidevine";
    version = "1.8.0";
    hash = "sha256-wU8/4oZEc0FrnKpz2aISUaAtchOObVTYwaP0S3prBck=";
  };

  pythonRelaxDeps = [ "protobuf" ];

  build-system = [ poetry-core ];

  dependencies = [
    click
    construct
    protobuf
    pycryptodome
    pymp4
    pyyaml
    requests
    unidecode
  ];

  doCheck = false;

  meta = {
    description = "Python implementation of Google's Widevine CDM";
    homepage = "https://github.com/devine-project/pywidevine";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ bdim404 ];
  };
}
