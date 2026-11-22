{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "grandstream-home-api";
  version = "0.1.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wtxu-gs";
    repo = "grandstream_home_api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NBxd+TQkpWQ9g4EQJPleO32ve9IVUnWJUANvZtt4p04=";
  };

  build-system = [ hatchling ];

  dependencies = [
    cryptography
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "grandstream_home_api" ];

  meta = {
    description = "Python API library for Grandstream GDS/GSC, GNS and GWN Switch devices";
    homepage = "https://github.com/wtxu-gs/grandstream_home_api";
    changelog = "https://github.com/wtxu-gs/grandstream_home_api/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
