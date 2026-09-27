{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  lxml,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-cas";
  version = "1.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-cas";
    repo = "python-cas";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1BENcYSVFdZuppbHV3/aRX8wmL1gaguuPngZOSNsoSM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    lxml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cas" ];

  meta = {
    description = "Python CAS (Central Authentication Service) client library";
    homepage = "https://github.com/python-cas/python-cas";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
