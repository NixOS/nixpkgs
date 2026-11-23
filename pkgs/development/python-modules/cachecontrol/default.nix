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
  version = "0.15.0";
  pyproject = true;

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "psf";
    repo = "cachecontrol";
    tag = "v${version}";
    hash = "sha256-NT+XHQmRC0uDrwi3ia1SumcHjcLqxOvtvZOCnUjf1Tw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.6,<0.14.0" uv_build
  '';

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

  meta = {
    description = "Httplib2 caching for requests";
    mainProgram = "doesitcache";
    homepage = "https://github.com/psf/cachecontrol";
    changelog = "https://github.com/psf/cachecontrol/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
