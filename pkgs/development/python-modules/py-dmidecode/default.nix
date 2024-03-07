{ lib
, buildPythonPackage
, dmidecode
, fetchPypi
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "py-dmidecode";
  version = "0.1.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "py_dmidecode";
    inherit version;
    hash = "sha256-nMy/jOlg7yUPfGF27MN0NyVM0vuTIBuJTV2GKNP13UA=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    dmidecode
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "dmidecode"
  ];

  meta = with lib; {
    description = "Python library that parses the output of dmidecode";
    homepage = "https://github.com/zaibon/py-dmidecode/";
    changelog = "https://github.com/zaibon/py-dmidecode/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ davidtwco ];
    platforms = platforms.linux;
  };
}
