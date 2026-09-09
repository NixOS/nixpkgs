{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pycryptodome,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "hanna-cloud";
  version = "0.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bestycame";
    repo = "hanna_cloud";
    tag = finalAttrs.version;
    hash = "sha256-UYwM1IbU4LlgBBEbMYX5ovf5/8N1SwyeKTHz6TYZZ24=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pycryptodome
    requests
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "hanna_cloud" ];

  meta = {
    description = "Python client for the HannaCloud API";
    homepage = "https://github.com/bestycame/hanna_cloud";
    changelog = "https://github.com/bestycame/hanna_cloud/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
