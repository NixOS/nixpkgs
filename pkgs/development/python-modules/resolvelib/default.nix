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
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sarugaku";
    repo = "resolvelib";
    tag = version;
    hash = "sha256-AxxW6z51fZGqs5UwY3NEBQL8894uQDuRyVrKzol3ny0=";
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
    changelog = "https://github.com/sarugaku/resolvelib/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.isc;
    maintainers = [ ];
  };
}
