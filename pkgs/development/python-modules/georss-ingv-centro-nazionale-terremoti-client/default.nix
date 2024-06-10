{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  georss-client,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "georss-ingv-centro-nazionale-terremoti-client";
  version = "0.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-ingv-centro-nazionale-terremoti-client";
    rev = "refs/tags/v${version}";
    hash = "sha256-J72yd1D4mKCOsBRLMUXKnxmjr6g0IQApTTrWjklczN8=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ georss-client ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "georss_ingv_centro_nazionale_terremoti_client" ];

  meta = with lib; {
    description = "Python library for accessing the INGV Centro Nazionale Terremoti GeoRSS feed";
    homepage = "https://github.com/exxamalte/python-georss-ingv-centro-nazionale-terremoti-client";
    changelog = "https://github.com/exxamalte/python-georss-ingv-centro-nazionale-terremoti-client/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
