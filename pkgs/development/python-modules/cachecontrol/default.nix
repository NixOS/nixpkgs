{
  lib,
  buildPythonPackage,
  cherrypy,
  fetchFromGitHub,
  filelock,
  msgpack,
  pytestCheckHook,
  redis,
  requests,
  uv-build,
}:

buildPythonPackage rec {
  pname = "cachecontrol";
  version = "0.14.4";
  pyproject = true;

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "ionrock";
    repo = "cachecontrol";
    tag = "v${version}";
    hash = "sha256-627SqJocVOO0AfI8vswPqOr15MA/Lx7RLAdRAXzWu84=";
  };

  build-system = [ uv-build ];

  dependencies = [
    msgpack
    requests
  ];

  optional-dependencies = {
    filecache = [ filelock ];
    redis = [ redis ];
  };

  nativeCheckInputs = [
    cherrypy
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "cachecontrol" ];

  meta = with lib; {
    description = "Httplib2 caching for requests";
    mainProgram = "doesitcache";
    homepage = "https://github.com/ionrock/cachecontrol";
    changelog = "https://github.com/psf/cachecontrol/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
