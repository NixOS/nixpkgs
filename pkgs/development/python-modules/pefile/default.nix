{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pefile";
  version = "2024.8.26";
  pyproject = true;

  # DON'T fetch from github, the repo is >60 MB due to test artifacts, which we cannot use
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-P/bF2LQ+jDe7bm3VCFZY1linoL3NILagex/PwcTp1jI=";
  };

  build-system = [ setuptools ];

  # Test data contains proprietary executables and malware, and is therefore encrypted
  doCheck = false;

  pythonImportsCheck = [ "pefile" ];

  meta = {
    description = "Multi-platform Python module to parse and work with Portable Executable (aka PE) files";
    homepage = "https://github.com/erocarrera/pefile";
    changelog = "https://github.com/erocarrera/pefile/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pamplemousse ];
  };
}
