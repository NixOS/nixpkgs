{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytestcov
, pythonOlder
, pytestrunner
}:

buildPythonPackage rec {
  pname = "cpplint";
  version = "1.4.5";
  disabled = pythonOlder "3.5";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "08b384606136146ac1d32a2ffb60623a5dc1b20434588eaa0fa12a6e24eb3bf5";
  };
  
  # fixing pytest version is not necessary
  patchPhase = ''
    substituteInPlace test-requirements --replace 'pytest>=4.6,<5.0' 'pytest'
  '';
  
  checkInputs = [ pytestrunner pytest pytestcov];
  
  meta = with lib; {
    description = "Automated checker to ensure C++ files follow Google's style guide";
    homepage = "https://github.com/cpplint/cpplint";
    license = licenses.bsd3;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
