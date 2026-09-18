{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  prompt-toolkit,
}:

buildPythonPackage (finalAttrs: {
  pname = "clintermission";
  version = "0.3.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sebageek";
    repo = "clintermission";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e7C9IDr+mhVSfU8lMywjX1BYwFo/qegPNzabak7UPcY=";
  };

  build-system = [ setuptools ];

  dependencies = [ prompt-toolkit ];

  # repo contains no tests
  doCheck = false;

  pythonImportsCheck = [ "clintermission" ];

  meta = {
    description = "Non-fullscreen command-line selection menu";
    homepage = "https://github.com/sebageek/clintermission";
    changelog = "https://github.com/sebageek/clintermission/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
