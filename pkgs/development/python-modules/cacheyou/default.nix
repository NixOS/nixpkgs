{ lib
, buildPythonPackage
, cherrypy
, fetchPypi
, filelock
, msgpack
, pdm-backend
, pytestCheckHook
, pythonOlder
, redis
, requests
}:

buildPythonPackage rec {
  pname = "cacheyou";
  version = "23.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  __darwinAllowLocalNetworking = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fkCPFfSXj+oiR3NLMIYh919/4Wm0YWeVGccuioXWHV0=";
  };

  nativeBuildInputs = [
    pdm-backend
  ];

  propagatedBuildInputs = [
    msgpack
    requests
  ];

  passthru.optional-dependencies = {
    filecache = [
      filelock
    ];
    redis = [
      redis
    ];
  };

  nativeCheckInputs = [
    cherrypy
    pytestCheckHook
  ] ++ passthru.optional-dependencies.filecache;

  pythonImportsCheck = [
    "cacheyou"
  ];

  meta = {
    description = "The httplib2 caching algorithms packaged up for use with requests";
    homepage = "https://github.com/frostming/cacheyou";
    changelog = "https://github.com/frostming/cacheyou/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
