{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "apkinspector";
  version = "1.3.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "erev0s";
    repo = "apkInspector";
    rev = "refs/tags/v${version}";
    hash = "sha256-zVMY1KMUCSqctAAHOEFXM9yT1X0PDC75ETshF+fc4pU=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "apkInspector" ];

  meta = with lib; {
    description = "Module designed to provide detailed insights into the zip structure of APK files";
    homepage = "https://github.com/erev0s/apkInspector";
    changelog = "https://github.com/erev0s/apkInspector/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "apkInspector";
  };
}
