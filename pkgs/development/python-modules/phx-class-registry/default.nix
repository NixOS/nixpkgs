{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "class-registry";
  version = "4.1.0";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "todofixthis";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-kJbyUzyklVSvW6bBxTTTrY+WhfcV0GUf/+Pzyv+7sEA=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "class_registry" ];

  meta = with lib; {
    description = "Factory and registry pattern for Python classes";
    homepage = "https://class-registry.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [
      hrdinka
      tomhoule
    ];
  };
}
