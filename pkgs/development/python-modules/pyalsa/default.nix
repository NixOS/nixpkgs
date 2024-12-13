{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  alsa-lib,
  nix-update-script,
}:
let
  version = "1.2.12";
in
buildPythonPackage {
  pname = "pyalsa";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alsa-project";
    repo = "alsa-python";
    tag = "v${version}";
    hash = "sha256-a0hqYg4VE6L6PBPZW5aGPa5L16uI9eHGvoyZPMkqsMU=";
  };

  build-system = [ setuptools ];

  buildInputs = [ alsa-lib ];

  pythonImportsCheck = [ "pyalsa" ];

  # Checks require a working ALSA environment
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python bindings for the Advanced Linux Sound Architecture (ALSA)";
    homepage = "http://www.alsa-project.org";
    license = with lib.licenses; [ lgpl2Plus ];
    maintainers = with lib.maintainers; [ pluiedev ];
  };
}
