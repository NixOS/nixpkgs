{ lib
, aiohttp
, buildPythonPackage
, fetchpatch
, fetchPypi
, flit-core
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "aiohttp-remotes";
  version = "1.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "aiohttp_remotes";
    inherit version;
    hash = "sha256-+Vw6a+Xi3nRqhc6a9J7FSNptuDeNfoG7Fx7HexNWKmw=";
  };

  patches = [
    # https://github.com/aio-libs/aiohttp-remotes/pull/355
    (fetchpatch {
      name = "replace-flit-with-flit-core.patch";
      url = "https://github.com/aio-libs/aiohttp-remotes/commit/3d39ee9a03a1c96b8e798dc6acf98165da31da1f.patch";
      hash = "sha256-PSxEYHtl8R7m7fOUmyYukkKHXww0HbmGGfXEVgU092U=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --no-cov-on-fail --cov-branch --cov=aiohttp_remotes --cov-report=term --cov-report=html" ""
  '';

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    aiohttp
  ] ++ lib.optionals (pythonOlder "3.7") [
    typing-extensions
  ];

  pythonImportsCheck = [
    "aiohttp_remotes"
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
    "--asyncio-mode=auto"
  ];

  meta = with lib; {
    description = "Set of useful tools for aiohttp.web server";
    homepage = "https://github.com/wikibusiness/aiohttp-remotes";
    license = licenses.mit;
    maintainers = with maintainers; [ qyliss ];
  };
}
