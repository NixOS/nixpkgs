{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, inflection
, pbr
, tinycss2
, pytestCheckHook
, pytest-mock
}:

buildPythonPackage rec {
  pname = "qstylizer";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "blambright";
    repo = pname;
    rev = version;
    sha256 = "sha256-iEMxBpS9gOPubd9O8zpVmR5B7+UZJFkPuOtikO1a9v0=";
  };

  nativeBuildInputs = [
    pbr
  ];

  propagatedBuildInputs = [
    inflection
    tinycss2
  ];

  checkInputs = [
    pytestCheckHook
    pytest-mock
  ];

  preBuild = ''
    export PBR_VERSION=${version}
  '';

  meta = with lib; {
    description = "Qt stylesheet generation utility for PyQt/PySide ";
    homepage = "https://github.com/blambright/qstylizer";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
