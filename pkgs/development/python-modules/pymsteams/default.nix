{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pymsteams";
  version = "0.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rveachkc";
    repo = "pymsteams";
    tag = version;
    hash = "sha256-Ze25mcXCRaon6qzWzcltD8kwJTfrG2w5jMswXymmKo4=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ requests ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "pymsteams" ];

  meta = {
    description = "Python module to interact with Microsoft Teams";
    homepage = "https://github.com/rveachkc/pymsteams";
    changelog = "https://github.com/rveachkc/pymsteams/releases/tag/${version}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
