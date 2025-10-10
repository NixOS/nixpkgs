{
  lib,
  buildPythonPackage,
  diskcache,
  eventlet,
  fetchFromGitHub,
  more-itertools,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "fasteners";
  version = "0.20";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "harlowja";
    repo = "fasteners";
    tag = version;
    hash = "sha256-h8hlx3yl1+EgqCGE02O+wLejwxgJ5ZOs6nPrYUtHwn0=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    diskcache
    eventlet
    more-itertools
    pytestCheckHook
  ];

  pythonImportsCheck = [ "fasteners" ];

  enabledTestPaths = [ "tests/" ];

  meta = with lib; {
    description = "Module that provides useful locks";
    homepage = "https://github.com/harlowja/fasteners";
    changelog = "https://github.com/harlowja/fasteners/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
