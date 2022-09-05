{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, jinja2
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiohttp-jinja2";
  version = "1.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fDul6sBgtpH05QU0ry15/KKnVxLr0rJeb8sSlYWfkQs=";
  };

  propagatedBuildInputs = [
    aiohttp
    jinja2
  ];

  checkInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov=aiohttp_jinja2 --cov-report xml --cov-report html --cov-report term" ""
  '';

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  pythonImportsCheck = [
    "aiohttp_jinja2"
  ];

  # Tests are outdated (1.5)
  # pytest.PytestUnhandledCoroutineWarning: async def functions...
  doCheck = false;

  meta = with lib; {
    description = "Jinja2 support for aiohttp";
    homepage = "https://github.com/aio-libs/aiohttp_jinja2";
    license = licenses.asl20;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
