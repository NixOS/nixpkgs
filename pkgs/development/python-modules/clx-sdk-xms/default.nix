{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  iso8601,
  requests,
  setuptools,
  unstableGitUpdater,
}:

buildPythonPackage {
  pname = "clx-sdk-xms";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "clxcommunications";
    repo = "sdk-xms-python";
    # https://github.com/clxcommunications/sdk-xms-python/issues/4
    rev = "8d629cd7bcaf91eaafee265a825e3c52191f1425";
    hash = "sha256-qMR9OT+QAKZGwDuoZVAtfKD3PQB7rEU/iTRjgACVGBs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    iso8601
    requests
  ];

  pythonImportsCheck = [ "clx.xms" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Python SDK for the CLX Communications REST API (XMS) for sending and receiving SMS";
    homepage = "https://github.com/clxcommunications/sdk-xms-python";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
