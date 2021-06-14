{ buildPythonPackage
, fetchPypi
, lib
, vcversioner
, pytestrunner
, mock
, pytest
, pytest-asyncio
, pytest-trio
, twisted
, zipp ? null
, pyparsing ? null
, pyhamcrest
, futures ? null
, attrs ? null
, isPy27
}:

buildPythonPackage rec {
  pname = "pyee";
  version = "8.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "92dacc5bd2bdb8f95aa8dd2585d47ca1c4840e2adb95ccf90034d64f725bfd31";
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
  ] ++ lib.optional isPy27 [
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
