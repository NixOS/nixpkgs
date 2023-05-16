<<<<<<< HEAD
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
=======
{ lib, buildPythonPackage, fetchPypi, dmidecode }:

buildPythonPackage rec {
  pname = "py-dmidecode";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bv1vmhj8h520kj6slwpz16xfmgp117yjjkfyihkl5ix6mn5zkpa";
  };

  propagatedBuildInputs = [ dmidecode ];

  # Project has no tests.
  doCheck = false;
  pythonImportsCheck = [ "dmidecode" ];

  meta = with lib; {
    homepage = "https://github.com/zaibon/py-dmidecode/";
    description = "Python library that parses the output of dmidecode";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ davidtwco ];
    platforms = platforms.linux;
  };
}
