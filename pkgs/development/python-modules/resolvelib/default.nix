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
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sarugaku";
    repo = "resolvelib";
    tag = version;
    hash = "sha256-8ffJ1Jlb/hzKY4pfE3B95ip2e1CxUByiR0cul/ZnxxA=";
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
