{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyusb,
  tqdm,
  libusb1,
  setuptools,
  setuptools-git-versioning,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyfwup";
  version = "0.5.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "pyfwup";
    rev = "refs/tags/${version}";
    hash = "sha256-pC4yVojOj/MiuN3FE7hAY6Jv4bH9SVE5DJLP9mWJoLc=";
  };

  build-system = [
    setuptools
    setuptools-git-versioning
  ];

  dependencies = [
    pyusb
    tqdm
    libusb1
  ];

  pythonImportsCheck = [
    "fwup"
    "fwup_utils"
  ];

  meta = {
    description = "Python FirmWare UPgrader";
    homepage = "https://github.com/greatscottgadgets/pyfwup";
    changelog = "https://github.com/greatscottgadgets/pyfwup/blob/${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.msanft ];
  };
}
