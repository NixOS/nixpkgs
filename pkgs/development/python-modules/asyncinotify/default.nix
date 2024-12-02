{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "asyncinotify";
  version = "4.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "absperf";
    repo = "asyncinotify";
    rev = "refs/tags/v${version}";
    hash = "sha256-SzsPYVA5fBXVcv7vE3FB4jFkIRr6NBlTeHrPxf5d8Ks=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "asyncinotify" ];

  pytestFlagsArray = [ "test.py" ];

  meta = with lib; {
    description = "Module for inotify";
    homepage = "https://github.com/absperf/asyncinotify/";
    changelog = "https://github.com/absperf/asyncinotify/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ cynerd ];
  };
}
