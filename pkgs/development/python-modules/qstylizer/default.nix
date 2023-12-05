{ lib
, buildPythonPackage
, fetchFromGitHub
, inflection
, pbr
, pytest-mock
, pytestCheckHook
, pythonOlder
, tinycss2
}:

buildPythonPackage rec {
  pname = "qstylizer";
  version = "0.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "blambright";
    repo = pname;
    rev = version;
    hash = "sha256-QJ4xhaAoVO4/VncXKzI8Q5f/rPfctJ8CvfedkQVgZgQ=";
  };

  PBR_VERSION = version;

  nativeBuildInputs = [
    pbr
  ];

  propagatedBuildInputs = [
    inflection
    tinycss2
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  pythonImportsCheck = [
    "qstylizer"
  ];

  meta = with lib; {
    description = "Qt stylesheet generation utility for PyQt/PySide";
    homepage = "https://github.com/blambright/qstylizer";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
