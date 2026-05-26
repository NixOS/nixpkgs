{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  pyusb,
  pyserial,
  prompt-toolkit,
  libusb1,
  hid-parser,
  setuptools,
}:

buildPythonPackage rec {
  pname = "facedancer";
  version = "3.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "facedancer";
    tag = version;
    hash = "sha256-CJU+ltQ+bWBK5AGS2WMR5RMx4UblknrCAMZyIAG/1bQ=";
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
    pyusb
    pyserial
    prompt-toolkit
    libusb1
    hid-parser
  ];

  pythonImportsCheck = [
    "facedancer"
  ];

  meta = {
    changelog = "https://github.com/greatscottgadgets/facedancer/releases/tag/${src.tag}";
    description = "Implement your own USB device in Python, supported by a hardware peripheral such as Cynthion or GreatFET";
    homepage = "https://github.com/greatscottgadgets/facedancer";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      mog
      carlossless
    ];
    # https://github.com/greatscottgadgets/facedancer/issues/172
    broken = pythonAtLeast "3.14";
  };
}
