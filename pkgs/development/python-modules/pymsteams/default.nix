{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pymsteams";
  version = "0.2.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rveachkc";
    repo = "pymsteams";
    tag = version;
    hash = "sha256-SXFJrhT/5Jf3OVUnVfayNk4BvQ2YFZ6SDTADDQOo3Go=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "pymsteams" ];

  meta = with lib; {
    description = "Python module to interact with Microsoft Teams";
    homepage = "https://github.com/rveachkc/pymsteams";
    changelog = "https://github.com/rveachkc/pymsteams/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
