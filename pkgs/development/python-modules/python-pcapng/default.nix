{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "python-pcapng";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rshk";
    repo = "python-pcapng";
    tag = version;
    hash = "sha256-uyoutb4Hk2Wd3z7UopNxauMLGdYVOAhDNzRKclSr7No=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonImportsCheck = [ "pcapng" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/rshk/python-pcapng/blob/${src.tag}/CHANGELOG.rst";
    description = "Library to read/write the pcap-ng format used by various packet sniffers";
    homepage = "https://github.com/rshk/python-pcapng";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
