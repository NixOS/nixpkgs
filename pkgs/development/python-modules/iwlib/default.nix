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
    hash = "sha256-qAX2WXpw7jABq6jwOft7Lct13BXE54UvVZT9Y3kZbaE=";
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
