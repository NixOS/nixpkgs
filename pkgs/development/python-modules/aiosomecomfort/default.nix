{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, prettytable
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aiosomecomfort";
  version = "0.0.3";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mkmer";
    repo = "AIOSomecomfort";
    rev = "refs/tags/${version}";
    hash = "sha256-Qw0KR934GS7AuT3nRYaunypt091fZLRioVbNOp9JesY=";
  };

  postPatch = ''
    # https://github.com/mkmer/AIOSomecomfort/issues/1
    mv aiosomecomfort AIOSomecomfort
  '';

  propagatedBuildInputs = [
    aiohttp
    prettytable
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  # SyntaxError in test.py
  doCheck = false;

  meta = {
    description = "AsyicIO client for US models of Honeywell Thermostats";
    homepage = "https://github.com/mkmer/AIOSomecomfort";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
