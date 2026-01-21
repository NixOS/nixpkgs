{
  lib,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  protobuf,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "omemo-dr";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GLZUKzu37W3ONN0C8ysWQBmCuiTwFG3a4JHcuSx5pIQ=";
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
