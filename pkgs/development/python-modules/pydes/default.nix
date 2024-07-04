{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
}:

buildPythonPackage rec {
  pname = "pydes";
  version = "unstable-2019-01-08";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "twhiteman";
    repo = "pyDes";
    rev = "e988a5ffc9abb8010fc75dba54904d1c5dbe83db";
    sha256 = "0sic8wbyk5azb4d4m6zbc96lfqcw8s2pzcv9nric5yqc751613ww";
  };

  checkPhase = ''
    ${python.interpreter} test_pydes.py
  '';

  pythonImportsCheck = [ "pyDes" ];

  meta = with lib; {
    description = "Pure python module which implements the DES and Triple-DES encryption algorithms";
    homepage = "https://github.com/twhiteman/pyDes";
    license = licenses.mit;
    maintainers = with maintainers; [ j0hax ];
  };
}
