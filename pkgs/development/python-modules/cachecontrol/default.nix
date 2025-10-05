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
  redis,
  requests,
}:

buildPythonPackage rec {
  pname = "cachecontrol";
  version = "0.14.3";
  pyproject = true;

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "ionrock";
    repo = "cachecontrol";
    tag = "v${version}";
    hash = "sha256-V8RWTDxhKCvf5bz2j6anp8bkCzkicTRY+Kd6eHu1peg=";
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
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

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
