{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "aioshutil";
  version = "1.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kumaraditya303";
    repo = "aioshutil";
    tag = "v${version}";
    hash = "sha256-hSUNx43sIUPs4YfQ+H39FXTpj3oCMUqRzDdHX2OdRdE=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioshutil" ];

  meta = with lib; {
    description = "Asynchronous version of function of shutil module";
    homepage = "https://github.com/kumaraditya303/aioshutil";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
