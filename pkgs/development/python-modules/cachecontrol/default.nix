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
  version = "0.14.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "ionrock";
    repo = "cachecontrol";
    rev = "refs/tags/v${version}";
    hash = "sha256-qeTq2NfMOmNtjBItLmjxlaxqqy/Uvb6JfBpCBRvRLh4=";
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
    changelog = "https://github.com/psf/cachecontrol/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
