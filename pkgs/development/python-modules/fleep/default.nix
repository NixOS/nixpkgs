{ lib
, buildPythonPackage
, fetchFromGitHub
, python
}:

buildPythonPackage rec {
  pname = "fleep";
  version = "1.0.1";
  format = "setuptools";

  # Pypi version does not have tests
  src = fetchFromGitHub {
    owner = "floyernick";
    repo = "fleep-py";
    rev = "994bc2c274482d80ab13d89d8f7343eb316d3e44";
    hash = "sha256-TaU7njx98nxkhZawGMFqWj4g+yCtIX9aPWQHoamzfMY=";
  };

  patches = [
    ./0001-Fixing-paths-on-tests.patch
  ];

  checkPhase = ''
    ${python.interpreter} tests/maintest.py
    ${python.interpreter} tests/speedtest.py
  '';

  pythonImportsCheck = [ "fleep" ];

  meta = with lib; {
    description = "File format determination library";
    homepage = "https://github.com/floyernick/fleep-py";
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
