{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitLab,
  protobuf,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "omemo-dr";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "dev.gajim.org";
    owner = "gajim";
    repo = "omemo-dr";
    tag = "v${version}";
    hash = "sha256-8+uBO7Nl6YcEwthWmChqCTLvUelF8QJl+dHzkqbPVqM=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    cryptography
    protobuf
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "omemo_dr" ];

  meta = {
    description = "OMEMO Double Ratchet";
    homepage = "https://dev.gajim.org/gajim/omemo-dr/";
    changelog = "https://dev.gajim.org/gajim/omemo-dr/-/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
}
