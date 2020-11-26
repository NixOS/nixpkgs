{ buildPythonPackage, fetchPypi, lib, vcversioner, pytestrunner, mock, pytest, pytest-asyncio, pytest-trio, twisted, zipp, pyparsing, pyhamcrest, futures, attrs, stdenv, isPy27 }:

buildPythonPackage rec {
  pname = "pyee";
  version = "7.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "105n8jzw8vy6cm8mm5sm86mwyaqqr8zjh8w9xvcb7hp29p0vrihm";
  };

  buildInputs = [
    vcversioner
  ];

  checkInputs = [
    mock
    pyhamcrest
    pytest
    pytest-asyncio
    pytest-trio
    pytestrunner
    twisted
  ] ++ stdenv.lib.optional isPy27 [
    attrs
    futures
    pyparsing
    zipp
  ];

  meta = {
    description = "A port of Node.js's EventEmitter to python";
    homepage = "https://github.com/jfhbrook/pyee";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kmein ];
  };
}
