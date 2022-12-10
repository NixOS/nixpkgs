{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pygments
, pytestCheckHook
, uvloop
}:

buildPythonPackage rec {
  pname = "aiorun";
  version = "2021.10.1";
  format = "flit";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "cjrh";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9e1vUWDBv3BYWuKR/rZUvaIxFFetzBQaygXKnl4PDd8=";
  };

  propagatedBuildInputs = [
    pygments
  ];

  checkInputs = [
    pytestCheckHook
    uvloop
  ];

  # allow for writable directory for darwin
  preBuild = ''
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [
    "aiorun"
  ];

  meta = with lib; {
    description = "Boilerplate for asyncio applications";
    homepage = "https://github.com/cjrh/aiorun";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };
}
