{ lib
, buildPythonPackage
, cherrypy
, fetchFromGitHub
, lockfile
, mock
, msgpack
, pytestCheckHook
, pythonOlder
, redis
, requests
}:

buildPythonPackage rec {
  pname = "cachecontrol";
  version = "0.12.11";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "ionrock";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-uUPIQz/n347Q9G7NDOGuB760B/KxOglUxiS/rYjt5Po=";
  };

  postPatch = ''
    # https://github.com/ionrock/cachecontrol/issues/297
    substituteInPlace tests/test_etag.py --replace \
      "requests.adapters.HTTPResponse.from_httplib" \
      "urllib3.response.HTTPResponse.from_httplib"
  '';

  propagatedBuildInputs = [
    msgpack
    requests
  ];

  nativeCheckInputs = [
    cherrypy
    mock
    pytestCheckHook
  ] ++ passthru.optional-dependencies.filecache;

  pythonImportsCheck = [
    "cachecontrol"
  ];

  passthru.optional-dependencies = {
    filecache = [ lockfile ];
    redis = [ redis ];
  };

  meta = with lib; {
    description = "Httplib2 caching for requests";
    homepage = "https://github.com/ionrock/cachecontrol";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };
}
