{
  lib,
  buildPythonPackage,
  casttube,
  fetchFromGitHub,
  protobuf,
  pytestCheckHook,
  setuptools,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "pychromecast";
  version = "14.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "pychromecast";
    tag = version;
    hash = "sha256-XoJUo/tTicv3jIzhgXovu+EBPVftRutkha4ZfdUWLvw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
       --replace-fail "setuptools>=65.6,<85.0" setuptools \
       --replace-fail "wheel>=0.37.1,<0.49.0" wheel
  '';

  build-system = [ setuptools ];

  dependencies = [
    casttube
    protobuf
    zeroconf
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pychromecast" ];

  meta = {
    description = "Library for Python to communicate with the Google Chromecast";
    homepage = "https://github.com/home-assistant-libs/pychromecast";
    changelog = "https://github.com/home-assistant-libs/pychromecast/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
