{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, py
, mock

, iocapture
}:

buildPythonPackage rec {
  pname = "argh";
  version = "0.26.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e9535b8c84dc9571a48999094fda7f33e63c3f1b74f3e5f3ac0105a58405bb65";
  };

  checkInputs = [ pytest py mock  iocapture ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    homepage = http://github.com/neithere/argh/;
    description = "An unobtrusive argparse wrapper with natural syntax";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ domenkozar ];
  };

}
