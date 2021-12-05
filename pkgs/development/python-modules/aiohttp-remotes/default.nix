{ lib, aiohttp, buildPythonPackage, fetchPypi, pytest-aiohttp, pytestCheckHook
, pythonOlder, typing-extensions }:

buildPythonPackage rec {
  pname = "aiohttp-remotes";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "aiohttp_remotes";
    inherit version;
    sha256 = "e44f2c5fd5fc3305477c89bb25f14570589100cc58c48b36745d4239839d3174";
  };

  propagatedBuildInputs = [ aiohttp ]
    ++ lib.optionals (pythonOlder "3.7") [ typing-extensions ];

  checkInputs = [ pytest-aiohttp pytestCheckHook ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --no-cov-on-fail --cov-branch --cov=aiohttp_remotes --cov-report=term --cov-report=html" ""
  '';

  pythonImportsCheck = [ "aiohttp_remotes" ];

  meta = with lib; {
    description = "A set of useful tools for aiohttp.web server";
    homepage = "https://github.com/wikibusiness/aiohttp-remotes";
    license = licenses.mit;
    maintainers = with maintainers; [ qyliss ];
  };
}
