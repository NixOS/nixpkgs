{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, pytest
, pytestcov
, uvloop
}:

buildPythonPackage rec {
  pname = "aiorun";
  version = "2020.2.1";
  format = "flit";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "cjrh";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wcj8prkijb889ic8n6varms7xkwy028hhw0imgkd1i0p64lm3m4";
  };

  checkInputs = [
    pytest
    pytestcov
    uvloop
  ];

  # allow for writable directory for darwin
  preBuild = ''
    export HOME=$TMPDIR
  '';

  checkPhase = ''
     pytest
  '';

  meta = with lib; {
    description = "Boilerplate for asyncio applications";
    homepage = https://github.com/cjrh/aiorun;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
