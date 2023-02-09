{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "goodwe";
  version = "0.2.24";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "marcelblijleven";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-dcz9IEPr5n86NHne9lEDB0kERY8o+jUEqPmz6QMEF4Q=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "'marcelblijleven@gmail.com" "marcelblijleven@gmail.com" \
      --replace "version: file: VERSION" "version = ${version}"
  '';

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "goodwe"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];


  meta = with lib; {
    description = "Python library for connecting to GoodWe inverter";
    homepage = "https://github.com/marcelblijleven/goodwe";
    changelog = "https://github.com/marcelblijleven/goodwe/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
