{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  commentjson,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "resolvelib";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sarugaku";
    repo = "resolvelib";
    rev = version;
    hash = "sha256-oxyPn3aFPOyx/2aP7Eg2ThtPbyzrFT1JzWqy6GqNbzM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    commentjson
    pytestCheckHook
  ];

  pythonImportsCheck = [ "resolvelib" ];

  meta = with lib; {
    description = "Resolve abstract dependencies into concrete ones";
    homepage = "https://github.com/sarugaku/resolvelib";
    changelog = "https://github.com/sarugaku/resolvelib/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.isc;
    maintainers = [ ];
  };
}
