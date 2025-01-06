{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyfronius";
  version = "0.7.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nielstron";
    repo = "pyfronius";
    tag = "release-${version}";
    hash = "sha256-7GtY/6uuLe7K9T7xMVt2ytpA6MKVWnyEoLtA5dSMiH4=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyfronius" ];

  meta = {
    description = "Python module to communicate with Fronius Symo";
    homepage = "https://github.com/nielstron/pyfronius";
    changelog = "https://github.com/nielstron/pyfronius/releases/tag/release-${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    # https://github.com/nielstron/pyfronius/issues/18
    broken = lib.versionAtLeast aiohttp.version "3.10.1";
  };
}
