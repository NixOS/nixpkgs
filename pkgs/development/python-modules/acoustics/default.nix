{ lib, buildPythonPackage, fetchPypi
, pytest, numpy, scipy, matplotlib, pandas, tabulate, pythonOlder }:

buildPythonPackage rec {
  pname = "acoustics";
  version = "0.2.0.post1";

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ numpy scipy matplotlib pandas tabulate ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "738218db41ff1b1f932eabb700e400d84141af6f29392aab5f7be1b19758f806";
  };

  # Tests look in wrong place for test data
  doCheck = false;

  checkPhase = ''
    py.test tests
  '';

  disabled = pythonOlder "3.6";

  meta = with lib; {
    description = "A package for acousticians";
    maintainers = with maintainers; [ fridh ];
    license = with licenses; [ bsd3 ];
    homepage = https://github.com/python-acoustics/python-acoustics;
  };
}
