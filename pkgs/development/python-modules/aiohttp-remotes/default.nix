{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  flit,
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "aiohttp-remotes";
  version = "1.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "aiohttp_remotes";
    inherit version;
    sha256 = "f95c3a6be5e2de746a85ce9af49ec548da6db8378d7e81bb171ec77b13562a6c";
  };

  nativeBuildInputs = [ flit ];

  propagatedBuildInputs = [ aiohttp ] ++ lib.optionals (pythonOlder "3.7") [ typing-extensions ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --no-cov-on-fail --cov-branch --cov=aiohttp_remotes --cov-report=term --cov-report=html" ""
  '';

  pythonImportsCheck = [ "aiohttp_remotes" ];

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
