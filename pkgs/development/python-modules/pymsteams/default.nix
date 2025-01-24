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
  version = "0.2.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rveachkc";
    repo = "pymsteams";
    rev = "refs/tags/${version}";
    hash = "sha256-suPCAzjQp46+kKFiCtm65lxBbsn78Owq4dVmWCdhIpA=";
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
