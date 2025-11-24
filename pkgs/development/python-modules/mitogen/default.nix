{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mitogen";
  version = "0.3.33";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mitogen-hq";
    repo = "mitogen";
    tag = "v${version}";
    hash = "sha256-c3POiFLvCUMyYBh9tVCMLR+NkY8/ZLNVYNvitvh0v50=";
  };

  build-system = [ setuptools ];

  # Tests require network access and Docker support
  doCheck = false;

  pythonImportsCheck = [ "mitogen" ];

  meta = with lib; {
    description = "Python Library for writing distributed self-replicating programs";
    homepage = "https://github.com/mitogen-hq/mitogen";
    changelog = "https://github.com/mitogen-hq/mitogen/blob/${src.tag}/docs/changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
