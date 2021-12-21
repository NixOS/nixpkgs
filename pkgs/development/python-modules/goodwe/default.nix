{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "goodwe";
  version = "0.2.8";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "marcelblijleven";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ij87hyfv4c93nb4irpxax8p1i6swnm8b6ncs70s6z5sk7ipp663";
  };

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "'marcelblijleven@gmail.com" "marcelblijleven@gmail.com" \
      --replace "version: file: VERSION" "version = ${version}"
  '';

  pythonImportsCheck = [
    "goodwe"
  ];

  meta = with lib; {
    description = "Python library for connecting to GoodWe inverter";
    homepage = "https://github.com/marcelblijleven/goodwe";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
