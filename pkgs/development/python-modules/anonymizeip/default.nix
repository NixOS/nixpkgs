{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "anonymizeip";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "samuelmeuli";
    repo = "anonymize-ip";
    tag = "v${version}";
    hash = "sha256-54q2R14Pdnw4FAmBufeq5NozsqC7C4W6QQPcjTSkM48=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "anonymizeip" ];

  meta = {
    description = "Python library for anonymizing IP addresses";
    homepage = "https://github.com/samuelmeuli/anonymize-ip";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
  };
}
