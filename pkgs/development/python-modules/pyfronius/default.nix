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
    rev = "refs/tags/release-${version}";
    hash = "sha256-7GtY/6uuLe7K9T7xMVt2ytpA6MKVWnyEoLtA5dSMiH4=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyfronius" ];

  meta = with lib; {
    description = "Python module to communicate with Fronius Symo";
    homepage = "https://github.com/nielstron/pyfronius";
    changelog = "https://github.com/nielstron/pyfronius/releases/tag/release-${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    # https://github.com/nielstron/pyfronius/issues/18
    broken = versionAtLeast aiohttp.version "3.10.1";
  };
}
