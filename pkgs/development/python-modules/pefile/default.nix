{
  lib,
  buildPythonPackage,
  future,
  fetchPypi,
  setuptools-scm,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pefile";
  version = "2023.2.7";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  # DON'T fetch from github, the repo is >60 MB due to test artifacts, which we cannot use
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-guYRQASz1pEcd8OVPjg4ZUsEURuLZuhYPbcMZZmAF9w=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ future ];

  # Test data contains properitary executables and malware, and is therefore encrypted
  doCheck = false;

  pythonImportsCheck = [ "pefile" ];

  meta = with lib; {
    description = "Multi-platform Python module to parse and work with Portable Executable (aka PE) files";
    homepage = "https://github.com/erocarrera/pefile";
    changelog = "https://github.com/erocarrera/pefile/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
