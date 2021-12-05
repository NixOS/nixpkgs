{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook, pythonOlder }:

buildPythonPackage rec {
  pname = "goodwe";
  version = "0.2.7";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "marcelblijleven";
    repo = pname;
    rev = "v${version}";
    sha256 = "6/JAp7zK60+om4l14sLn+pUki0Q/5XwCJSawOf1q2q0=";
  };

  checkInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "'marcelblijleven@gmail.com" "marcelblijleven@gmail.com" \
      --replace "version: file: VERSION" "version = ${version}"
  '';

  pythonImportsCheck = [ "goodwe" ];

  meta = with lib; {
    description = "Python library for connecting to GoodWe inverter";
    homepage = "https://github.com/marcelblijleven/goodwe";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
