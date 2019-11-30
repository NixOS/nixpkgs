{ lib, buildPythonPackage, fetchPypi
, pytest, numpy, scipy, matplotlib, pandas, tabulate, pythonOlder }:

buildPythonPackage rec {
  pname = "acoustics";
  version = "0.2.3";

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ numpy scipy matplotlib pandas tabulate ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "ca663059d61fbd2899aed4e3cedbc3f983aa67afd3ae1617db3c59b724206fb3";
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
