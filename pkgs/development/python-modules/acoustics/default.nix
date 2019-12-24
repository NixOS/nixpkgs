{ lib, buildPythonPackage, fetchPypi
, pytest, numpy, scipy, matplotlib, pandas, tabulate, pythonOlder }:

buildPythonPackage rec {
  pname = "acoustics";
  version = "0.2.2";

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ numpy scipy matplotlib pandas tabulate ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "00981908c7cf54be58c0bfe902d7743225554ecf3432b30723e9300d9f3a0b0e";
  };

  checkPhase = ''
    pushd tests
    py.test ./.
    popd
  '';

  disabled = pythonOlder "3.6";

  meta = with lib; {
    description = "A package for acousticians";
    maintainers = with maintainers; [ fridh ];
    license = with licenses; [ bsd3 ];
    homepage = https://github.com/python-acoustics/python-acoustics;
  };
}
