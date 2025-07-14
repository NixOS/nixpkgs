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
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sarugaku";
    repo = "resolvelib";
    rev = version;
    hash = "sha256-UBdgFN+fvbjz+rp8+rog8FW2jwO/jCfUPV7UehJKiV8=";
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
