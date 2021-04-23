{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pygments
, pytestCheckHook
, pytest-cov
, uvloop
}:

buildPythonPackage rec {
  pname = "aiorun";
  version = "2020.12.1";
  format = "flit";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "cjrh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ktc2cmoPNYcsVyKCWs+ivhV5onywFIrdDRBiBKrdiF4=";
  };

  propagatedBuildInputs = [
    pygments
  ];

  checkInputs = [
    pytestCheckHook
    pytest-cov
    uvloop
  ];

  # allow for writable directory for darwin
  preBuild = ''
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [ "aiorun" ];

  meta = with lib; {
    description = "Boilerplate for asyncio applications";
    homepage = "https://github.com/cjrh/aiorun";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };
}
