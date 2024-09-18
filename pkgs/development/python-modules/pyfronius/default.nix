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
    rev = "release-${version}";
    hash = "sha256-7GtY/6uuLe7K9T7xMVt2ytpA6MKVWnyEoLtA5dSMiH4=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ aiohttp ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyfronius" ];

  meta = with lib; {
    description = "Python module to communicate with Fronius Symo";
    homepage = "https://github.com/nielstron/pyfronius";
    changelog = "https://github.com/nielstron/pyfronius/releases/tag/release-${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
