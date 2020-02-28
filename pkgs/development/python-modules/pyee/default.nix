{ lib
, buildPythonPackage
, fetchPypi
, vcversioner
, pytest-asyncio
, pytestrunner
, pytest-trio
}:

buildPythonPackage rec {
  pname = "pyee";
  version = "7.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b0e5b89b17c8bd52a3c6517a545187907a8c69ce90169d29ebd8d2d5d7e4bc7d";
  };

  buildInputs = [
    vcversioner
    pytest-asyncio
    pytestrunner
    pytest-trio
  ];

  meta = with lib; {
    description = "A port of node.js's EventEmitter to python";
    homepage = https://github.com/jfhbrook/pyee;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
