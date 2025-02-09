{
  lib,
  buildPythonPackage,
  cherrypy,
  fetchFromGitHub,
  flit-core,
  filelock,
  mock,
  msgpack,
  pytestCheckHook,
  pythonOlder,
  redis,
  requests,
}:

buildPythonPackage rec {
  pname = "cachecontrol";
  version = "0.14.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "ionrock";
    repo = "cachecontrol";
    tag = "v${version}";
    hash = "sha256-m3ywSskVtZrOA+ksLz5XZflAJsbSAjdJsRpeq341q70=";
  };

  build-system = [ flit-core ];

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
    mock
    pytestCheckHook
    requests
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

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
