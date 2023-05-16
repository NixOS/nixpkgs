{ lib
, buildPythonPackage
, cherrypy
, fetchFromGitHub
<<<<<<< HEAD
, flit-core
, filelock
=======
, lockfile
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, mock
, msgpack
, pytestCheckHook
, pythonOlder
, redis
, requests
}:

buildPythonPackage rec {
  pname = "cachecontrol";
<<<<<<< HEAD
  version = "0.13.1";
  format = "pyproject";
=======
  version = "0.12.11";
  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.6";

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "ionrock";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-4N+vk65WxOrT+IJRn+lEnbs5vlWQh9ievVHWWe3BKJ0=";
=======
    rev = "v${version}";
    hash = "sha256-uUPIQz/n347Q9G7NDOGuB760B/KxOglUxiS/rYjt5Po=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    # https://github.com/ionrock/cachecontrol/issues/297
    substituteInPlace tests/test_etag.py --replace \
      "requests.adapters.HTTPResponse.from_httplib" \
      "urllib3.response.HTTPResponse.from_httplib"
  '';

<<<<<<< HEAD
  nativeBuildInputs = [
    flit-core
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    msgpack
    requests
  ];

<<<<<<< HEAD
  passthru.optional-dependencies = {
    filecache = [
      filelock
    ];
    redis = [
      redis
    ];
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    cherrypy
    mock
    pytestCheckHook
<<<<<<< HEAD
    requests
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);
=======
  ] ++ passthru.optional-dependencies.filecache;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  pythonImportsCheck = [
    "cachecontrol"
  ];

<<<<<<< HEAD
  meta = with lib; {
    description = "Httplib2 caching for requests";
    homepage = "https://github.com/ionrock/cachecontrol";
    changelog = "https://github.com/psf/cachecontrol/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
=======
  passthru.optional-dependencies = {
    filecache = [ lockfile ];
    redis = [ redis ];
  };

  meta = with lib; {
    description = "Httplib2 caching for requests";
    homepage = "https://github.com/ionrock/cachecontrol";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
