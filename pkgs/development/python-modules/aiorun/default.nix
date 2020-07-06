{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, pygments
, pytest
, pytestcov
, uvloop
}:

buildPythonPackage rec {
  pname = "aiorun";
  version = "2020.6.1";
  format = "flit";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "cjrh";
    repo = pname;
    rev = "v${version}";
    sha256 = "00mq5ylhhdfdqrh7zdqabf3wy85jrkqvgfb1421ll46fsjim2d14";
  };

  propagatedBuildInputs = [
    pygments
  ];

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
    homepage = "https://github.com/cjrh/aiorun";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
