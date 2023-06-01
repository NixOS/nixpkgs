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
  version = "2022.11.1";
  format = "flit";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "cjrh";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-1qXt3HT/0sECOqPRwc0p+5+YZh1kyHSbkZHajcrjvZc=";
  };

  propagatedBuildInputs = [
    pygments
  ];

  nativeCheckInputs = [
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
    changelog = "https://github.com/cjrh/aiorun/blob/v${version}/CHANGES";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };
}
