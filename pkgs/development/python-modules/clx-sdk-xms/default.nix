{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  iso8601,
  requests,
  setuptools,
}:

buildPythonPackage {
  pname = "clx-sdk-xms";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "clxcommunications";
    repo = "sdk-xms-python";
    # Release 1.0.0. Upstream does not tag releases.
    # https://github.com/clxcommunications/sdk-xms-python/issues/4
    rev = "72cb5e8e449c5b37d7fa2d6a31c988694d1d0e0d";
    hash = "sha256-m3SCW15U8YSl7k019NKfaygSZKkqTr4CRmLmAodXg6o=";
  };

  build-system = [ setuptools ];

  dependencies = [
    iso8601
    requests
  ];

  pythonImportsCheck = [ "clx.xms" ];

  meta = {
    description = "Python SDK for the CLX Communications REST API (XMS) for sending and receiving SMS";
    homepage = "https://github.com/clxcommunications/sdk-xms-python";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
