{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "kivy-garden";
  version = "0.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kivy-garden";
    repo = "garden";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xOMBPFKV7mTa51Q0VKja7b0E509IaWjwlJVlSRVdct8=";
  };

  patches = [
    # See https://github.com/kivy-garden/garden/commit/6257325da4b91c8cd288bfb107c366703f9f17c2
    ./fix-name.diff
    ./remove-import-pkg-resources.diff
  ];

  build-system = [ setuptools ];

  dependencies = [ requests ];

  pythonImportsCheck = [ "garden" ];

  # There are no tests
  doCheck = false;

  meta = {
    description = "Kivy garden installation script, split into its own package for convenient use in buildozer";
    homepage = "https://github.com/kivy-garden/garden";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ risson ];
  };
})
