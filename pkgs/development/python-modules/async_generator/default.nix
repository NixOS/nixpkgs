{ lib, buildPythonPackage, fetchPypi, pythonOlder, pytest, pytest-asyncio }:

buildPythonPackage rec {
  pname = "async_generator";
  version = "1.9";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b7d5465c6174fe86dba498ececb175f93a6097ffb7cc91946405e1f05b848371";
  };

  checkInputs = [ pytest pytest-asyncio ];

  checkPhase = ''
    pytest -W error -ra -v --pyargs async_generator
  '';

  meta = with lib; {
    description = "Async generators and context managers for Python 3.5+";
    homepage = https://github.com/python-trio/async_generator;
    license = with licenses; [ mit asl20 ];
  };
}
