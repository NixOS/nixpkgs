{
  lib,
  buildPythonPackage,
  casttube,
  fetchFromGitHub,
  pythonOlder,
  protobuf,
  setuptools,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "pychromecast";
  version = "14.0.6";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "pychromecast";
    tag = version;
    hash = "sha256-fyF/3F/K4bSOEepCArhK+v+W6tet82r1EW22g74mQlw=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    casttube
    protobuf
    zeroconf
  ];

  # no tests available
  doCheck = false;

  pythonImportsCheck = [ "pychromecast" ];

  meta = with lib; {
    description = "Library for Python to communicate with the Google Chromecast";
    homepage = "https://github.com/home-assistant-libs/pychromecast";
    changelog = "https://github.com/home-assistant-libs/pychromecast/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
  };
}
