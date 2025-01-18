{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mitogen";
  version = "0.3.20";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mitogen-hq";
    repo = "mitogen";
    tag = "v${version}";
    hash = "sha256-XA4ra06OHUV67HF093Mfi0M+Dd6K3gMnOYeOB663DhA=";
  };

  build-system = [ setuptools ];

  # Tests require network access and Docker support
  doCheck = false;

  pythonImportsCheck = [ "mitogen" ];

  meta = with lib; {
    description = "Python Library for writing distributed self-replicating programs";
    homepage = "https://github.com/mitogen-hq/mitogen";
    changelog = "https://github.com/mitogen-hq/mitogen/blob/v${version}/docs/changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
