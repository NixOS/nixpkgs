{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  georss-client,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "georss-ingv-centro-nazionale-terremoti-client";
  version = "2026.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-ingv-centro-nazionale-terremoti-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W/uPz4Kp3j5fNTocCYKMqpCNnwGioucYk6Q4tRKyPL4=";
  };

  build-system = [ setuptools ];

  dependencies = [ georss-client ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "georss_ingv_centro_nazionale_terremoti_client" ];

  meta = {
    description = "Python library for accessing the INGV Centro Nazionale Terremoti GeoRSS feed";
    homepage = "https://github.com/exxamalte/python-georss-ingv-centro-nazionale-terremoti-client";
    changelog = "https://github.com/exxamalte/python-georss-ingv-centro-nazionale-terremoti-client/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
