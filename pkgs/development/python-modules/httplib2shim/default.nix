{
  lib,
  buildPythonPackage,
  certifi,
  fetchFromGitHub,
  httplib2,
  nix-update-script,
  setuptools,
  six,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "httplib2shim";
  version = "0.0.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "httplib2shim";
    tag = finalAttrs.version;
    hash = "sha256-1dBrO8vkqJKsz+ADZNRtjUr+eVRGdt4iN1GFrse1sFc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    certifi
    httplib2
    six
    urllib3
  ];

  # Tests require a network access
  doCheck = false;

  pythonImportsCheck = [ "httplib2shim" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Urllib3 sanity for httplib2 users";
    homepage = "https://github.com/GoogleCloudPlatform/httplib2shim";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
