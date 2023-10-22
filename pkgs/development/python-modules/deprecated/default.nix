{ lib
, fetchFromGitHub
, buildPythonPackage
, wrapt
, pytestCheckHook
, sphinxHook
}:

buildPythonPackage rec {
  pname = "deprecated";
  version = "1.2.14";
  outputs = [ "out" "doc" ];

  src = fetchFromGitHub {
    owner = "tantale";
    repo = "deprecated";
    rev = "refs/tags/v${version}";
    hash = "sha256-H5Gp2F/ChMeEH4fSYXIB34syDIzDymfN949ksJnS0k4=";
  };

  nativeBuildInputs = [
    sphinxHook
  ];

  propagatedBuildInputs = [
    wrapt
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "deprecated" ];

  meta = with lib; {
    homepage = "https://github.com/tantale/deprecated";
    description = "Python @deprecated decorator to deprecate old python classes, functions or methods";
    license = licenses.mit;
    maintainers = with maintainers; [ tilpner ];
  };
}
