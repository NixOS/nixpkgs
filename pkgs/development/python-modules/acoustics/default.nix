{ lib, buildPythonPackage, fetchPypi
, pytest, numpy, scipy, matplotlib, pandas, tabulate, pythonOlder }:

buildPythonPackage rec {
  pname = "acoustics";
  version = "0.2.4.post0";

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ numpy scipy matplotlib pandas tabulate ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "a162625e5e70ed830fab8fab0ddcfe35333cb390cd24b0a827bcefc5bbcae97d";
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
    homepage = "https://github.com/python-acoustics/python-acoustics";
  };
}
