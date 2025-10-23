{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  requests,
  responses,
  setuptools,
}:

buildPythonPackage rec {
  pname = "nvdlib";
  version = "0.8.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Vehemont";
    repo = "nvdlib";
    tag = "v${version}";
    hash = "sha256-FjeYJMMccao9KJMcJBKtt5QhpQEEbcPyNunj+VqMdx0=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "nvdlib" ];

  meta = with lib; {
    description = "Module to interact with the National Vulnerability CVE/CPE API";
    homepage = "https://github.com/Vehemont/nvdlib/";
    changelog = "https://github.com/vehemont/nvdlib/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
