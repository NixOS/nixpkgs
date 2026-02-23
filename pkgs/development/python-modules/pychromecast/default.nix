{
  lib,
  buildPythonPackage,
  casttube,
  fetchFromGitHub,
  protobuf,
  setuptools,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "pychromecast";
  version = "14.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "pychromecast";
    tag = version;
    hash = "sha256-SpoVgXJV/9SVAcZXfeqpB3jkt9UUWcY9NBDGeIFhh4w=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
       --replace-fail "setuptools>=65.6,<81.0" setuptools \
       --replace-fail "wheel>=0.37.1,<0.46.0" wheel
  '';

  build-system = [ setuptools ];

  dependencies = [
    casttube
    protobuf
    zeroconf
  ];

  # no tests available
  doCheck = false;

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
