{ lib
, buildPythonPackage
, cherrypy
, fetchFromGitHub
, flit-core
, filelock
, mock
, msgpack
, pytestCheckHook
, pythonOlder
, redis
, requests
}:

buildPythonPackage rec {
  pname = "cachecontrol";
  version = "0.13.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "ionrock";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-4N+vk65WxOrT+IJRn+lEnbs5vlWQh9ievVHWWe3BKJ0=";
  };

  postPatch = ''
    # https://github.com/ionrock/cachecontrol/issues/297
    substituteInPlace tests/test_etag.py --replace \
      "requests.adapters.HTTPResponse.from_httplib" \
      "urllib3.response.HTTPResponse.from_httplib"
  '';

  nativeBuildInputs = [
    flit-core
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
    mock
    pytestCheckHook
    requests
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "cachecontrol"
  ];

  meta = with lib; {
    description = "Httplib2 caching for requests";
    homepage = "https://github.com/ionrock/cachecontrol";
    changelog = "https://github.com/psf/cachecontrol/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
