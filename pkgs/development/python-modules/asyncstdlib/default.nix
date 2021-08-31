{ lib
, buildPythonPackage
, fetchFromGitHub
, typing-extensions
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "asyncstdlib";
  version = "3.9.2";
  disabled = pythonOlder "3.7";
  format = "flit";

  src = fetchFromGitHub {
    owner = "maxfischer2781";
    repo = pname;
    rev = "v${version}";
    sha256 = "04z0x2n4a7503h6xf853p7if218magi98x397648wb21l4gh3zwv";
  };

  propagatedBuildInputs = [
    typing-extensions
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "asyncstdlib" ];

  meta = with lib; {
    description = "Python library that extends the Python asyncio standard library";
    homepage = "https://asyncstdlib.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
