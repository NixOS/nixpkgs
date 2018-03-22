{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pythonOlder
}:

if !(pythonOlder "3.3") then null else buildPythonPackage rec {
  pname = "backports.shutil_get_terminal_size";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "713e7a8228ae80341c70586d1cc0a8caa5207346927e23d09dcbcaf18eadec80";
  };

  checkInputs = [
    pytest
  ];

  meta = {
    description = "A backport of the get_terminal_size function from Python 3.3’s shutil.";
    homepage = https://github.com/chrippa/backports.shutil_get_terminal_size;
    license = with lib.licenses; [ mit ];
  };
}