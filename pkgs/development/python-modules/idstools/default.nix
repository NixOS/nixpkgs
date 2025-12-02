{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  setuptools,
  sphinx,
  sphinxcontrib-programoutput,
}:

buildPythonPackage rec {
  pname = "idstools";
  version = "0.6.5";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "jasonish";
    repo = "py-idstools";
    tag = version;
    hash = "sha256-sDar3piE9elMKQ6sg+gUw95Rr/RJOSCfV0VFiBURNg4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    python-dateutil
    sphinx
    sphinxcontrib-programoutput
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "idstools" ];

  meta = {
    description = "Module to work with Snort and Suricata Rule and Event";
    homepage = "https://github.com/jasonish/py-idstools";
    changelog = "https://github.com/jasonish/py-idstools/releases/tag/${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
}
