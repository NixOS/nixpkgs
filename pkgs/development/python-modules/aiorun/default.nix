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
  version = "2020.1.3";
  format = "flit";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "cjrh";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ka0pj6xr47j7rw6kd5mkrr5jyhn631pfpd95ig7vbln4434qnb4";
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
