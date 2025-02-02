{
  lib,
  buildPythonPackage,
  fetchPypi,
  wirelesstools,
  cffi,
  pytest,
}:
buildPythonPackage rec {
  pname = "iwlib";
  version = "1.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a805f6597a70ee3001aba8f039fb7b2dcb75dc15c4e7852f5594fd6379196da1";
  };

  propagatedBuildInputs = [
    wirelesstools
    cffi
  ];
  nativeBuildInputs = [ pytest ];
  pythonImportsCheck = [ "iwlib" ];

  doCheck = true;
  checkInputs = [ pytest ];
  checkPhase = "python iwlib/_iwlib_build.py; pytest -v";

  meta = with lib; {
    homepage = "https://github.com/nhoad/python-iwlib";
    description = "Python interface for the Wireless Tools utility collection";
    changelog = "https://github.com/nhoad/python-iwlib#change-history";
    maintainers = with maintainers; [ jcspeegs ];
    license = licenses.gpl2Only;
  };
}
