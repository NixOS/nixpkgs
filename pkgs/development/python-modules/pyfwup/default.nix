{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyusb,
  tqdm,
  libusb1,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyfwup";
  version = "0.5.2";

  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "pyfwup";
    rev = "refs/tags/${version}";
    hash = "sha256-Kyc3f8beTg0W1+U7SvZuNPN1pdsco9rBUfoEtR7AI44=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  dependencies = [
    pyusb
    tqdm
    libusb1
  ];

  build-system = [ setuptools ];

  pythonImportsCheck = [
    "fwup"
    "fwup_utils"
  ];

  meta = {
    description = "Python FirmWare UPgrader";
    homepage = "https://github.com/greatscottgadgets/pyfwup";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.msanft ];
  };
}
