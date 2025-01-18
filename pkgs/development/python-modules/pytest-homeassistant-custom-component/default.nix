{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
}:

buildPythonPackage rec {
  pname = "pytest-homeassistant-custom-component";
  version = "0.13.203";

  src = fetchFromGitHub {
    owner = "MatthewFlamm";
    repo = "pytest-homeassistant-custom-component";
    rev = "${version}";
    sha256 = "sha256-zxP/j6o4x9VjngTIoTDeTciNVav25OmGA6mFgf42bEk=";
  };

  meta = {
    description = "Package to automatically extract testing plugins from Home Assistant for custom component testing";
    homepage = "https://github.com/MatthewFlamm/pytest-homeassistant-custom-component";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nealfennimore ];
  };
}
