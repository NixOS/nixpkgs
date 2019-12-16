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
  version = "2019.11.1";
  format = "flit";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "cjrh";
    repo = pname;
    rev = "v${version}";
    sha256 = "04p3sci6af6qqfkcqamsqhmqqrigcwvl4bmx8yv5ppvkyq39pxi7";
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
