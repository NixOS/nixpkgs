{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  keystoneauth1,
  multipart,
  pythonOlder,
  setuptools,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "keystoneauth_websso";
  version = "0.2.0";

  disabled = pythonOlder "3.8";
  format = "pyproject";

  src = fetchFromGitHub {
    tag = "v${version}";
    owner = "vexxhost";
    repo = "keystoneauth-websso";
    hash = "sha256-6Ueu2KJVFEQvhfvVK0lBmhIwA0qxDsqEcXglMXVWanI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    keystoneauth1
    multipart
  ];

  nativeCheckInputs = [ poetry-core ];
  pythonImportsCheck = [ "keystoneauth_websso" ];

  meta = {
    description = "WebSSO CLI support for OpenStack keystoneauth library";
    homepage = "https://github.com/vexxhost/keystoneauth-websso";
    changelog = "https://github.com/vexxhost/keystoneauth-websso/blob/main/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ skrobul ];
  };
}
