{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  georss-client,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "georss-ingv-centro-nazionale-terremoti-client";
  version = "0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-ingv-centro-nazionale-terremoti-client";
    tag = "v${version}";
    hash = "sha256-J72yd1D4mKCOsBRLMUXKnxmjr6g0IQApTTrWjklczN8=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ georss-client ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "georss_ingv_centro_nazionale_terremoti_client" ];

  meta = {
    description = "Python library for accessing the INGV Centro Nazionale Terremoti GeoRSS feed";
    homepage = "https://github.com/exxamalte/python-georss-ingv-centro-nazionale-terremoti-client";
    changelog = "https://github.com/exxamalte/python-georss-ingv-centro-nazionale-terremoti-client/releases/tag/v${version}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
    broken = true; # Sends a dict to georss_client.xml_parser which expects a string or character stream
  };
}
