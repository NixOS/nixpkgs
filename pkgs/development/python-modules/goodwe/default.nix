{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "goodwe";
  version = "0.2.20";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "marcelblijleven";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-RDd0KR7NjBTlgeQ/E4mnLnB2n4NCPoAt2a62NGdzCZE=";
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
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
