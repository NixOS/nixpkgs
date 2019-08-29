{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, wrapt
, typing
, pyserial
, nose
, mock
, hypothesis
, future
, pytest
, pytest-timeout }:

buildPythonPackage rec {
  pname = "python-can";
  version = "3.1.0";

  # PyPI tarball is missing some tests and is missing __init__.py in test
  # directory causing the tests to fail. See:
  # https://github.com/hardbyte/python-can/issues/518
  src = fetchFromGitHub {
    repo = pname;
    owner = "hardbyte";
    rev = "v${version}";
    sha256 = "01lfsh7drm4qvv909x9i0vnhskdh27mcb5xa86sv9m3zfpq8cjis";
  };

  propagatedBuildInputs = [ wrapt pyserial ] ++ lib.optional (pythonOlder "3.5") typing;
  checkInputs = [ nose mock pytest pytest-timeout hypothesis future ];

  # Add the scripts to PATH
  checkPhase = ''
    PATH=$out/bin:$PATH pytest -c /dev/null
  '';

  meta = with lib; {
    homepage = https://github.com/hardbyte/python-can;
    description = "CAN support for Python";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ sorki ];
  };
}
