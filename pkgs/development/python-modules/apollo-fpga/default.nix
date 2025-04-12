{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  deprecation,
  prompt-toolkit,
  pyusb,
  pyvcd,
  pyxdg,
}:

buildPythonPackage rec {
  pname = "apollo-fpga";
  version = "1.1.1";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "apollo";
    rev = "refs/tags/v${version}";
    hash = "sha256-EDI+bRDePEbkxfQKuDgRsJtlAE0jqcIoQHjpgW0jIoY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    deprecation
    prompt-toolkit
    pyusb
    pyvcd
    pyxdg
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [
    "apollo_fpga"
  ];

  meta = {
    changelog = "https://github.com/greatscottgadgets/apollo/releases/tag/v${version}";
    description = "microcontroller-based FPGA / JTAG programmer";
    homepage = "https://github.com/greatscottgadgets/apollo";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ carlossless ];
  };
}
