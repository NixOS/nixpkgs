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
  version = "1.6";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "kumaraditya303";
    repo = "aioshutil";
    tag = "v${version}";
    hash = "sha256-+8BpL9CVH0X/9H7vL4xuV5CdA3A10a2A1q4wt1x1sSM=";
  };

  build-system = [ setuptools-scm ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioshutil" ];

  meta = with lib; {
    description = "Asynchronous version of function of shutil module";
    homepage = "https://github.com/kumaraditya303/aioshutil";
    changelog = "https://github.com/kumaraditya303/aioshutil/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
