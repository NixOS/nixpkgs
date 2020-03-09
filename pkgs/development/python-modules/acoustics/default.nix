{ lib, buildPythonPackage, fetchPypi
, pytest, numpy, scipy, matplotlib, pandas, tabulate, pythonOlder }:

buildPythonPackage rec {
  pname = "acoustics";
  version = "0.2.4";

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ numpy scipy matplotlib pandas tabulate ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ccb68ac258ba81a0b9064523e85eae013f9bfce7244d01db42d7d2d21d712cc";
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
