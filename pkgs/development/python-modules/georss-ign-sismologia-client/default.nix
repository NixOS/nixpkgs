{
  lib,
  buildPythonPackage,
  dateparser,
  fetchFromGitHub,
  georss-client,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "georss-ign-sismologia-client";
  version = "2026.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-ign-sismologia-client";
    tag = "v${version}";
    hash = "sha256-qAgV6w+wsZ3sJwegrWuZ8cp7ZlRws04Qjn1frZ334IU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dateparser
    georss-client
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "georss_ign_sismologia_client" ];

  meta = {
    description = "Python library for accessing the IGN Sismologia GeoRSS feed";
    homepage = "https://github.com/exxamalte/python-georss-ign-sismologia-client";
    changelog = "https://github.com/exxamalte/python-georss-ign-sismologia-client/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
