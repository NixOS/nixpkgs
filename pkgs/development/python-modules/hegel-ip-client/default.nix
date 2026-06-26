{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "hegel-ip-client";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "boazca";
    repo = "hegel-ip-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IKOtZ6mxbFvH1cLT45j/OD3OzAwy6vmtdF584LS5M7A=";
  };

  build-system = [ setuptools ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "hegel_ip_client" ];

  meta = {
    description = "Python client library for Hegel amplifiers";
    homepage = "https://github.com/boazca/hegel-ip-client";
    changelog = "https://github.com/boazca/hegel-ip-client/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
