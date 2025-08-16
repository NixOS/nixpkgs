{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pyusb,
  pyserial,
  prompt-toolkit,
  libusb1,
  setuptools,
}:

buildPythonPackage rec {
  pname = "facedancer";
  version = "3.1.1";
  pyproject = true;
  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "facedancer";
    tag = version;
    hash = "sha256-Qe8DPUKwlukPftc7SOZIcY/do/14UdS61WH0g5dFeMI=";
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
  };
}
