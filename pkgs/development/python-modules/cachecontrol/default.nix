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
  version = "0.14.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "ionrock";
    repo = "cachecontrol";
    rev = "refs/tags/v${version}";
    hash = "sha256-myyqiUGna+5S2GJGnwZTOfLh49NhjfHAvpUB49dQbgY=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    msgpack
    requests
  ];

  passthru.optional-dependencies = {
    filecache = [ filelock ];
    redis = [ redis ];
  };

  nativeCheckInputs = [
    cherrypy
    mock
    pytestCheckHook
    requests
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

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
