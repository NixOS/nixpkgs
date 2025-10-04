{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "nhc";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vandeurenglenn";
    repo = "nhc";
    tag = "v${version}";
    hash = "sha256-eEzubHmnaj1Z7XKlpQff4VLlNNllnBh7pDmNT5Yfw+E=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "nhc" ];

  # upstream has no test
  doCheck = false;

  meta = {
    changelog = "https://github.com/VandeurenGlenn/nhc/blob/${src.tag}/CHANGELOG.md";
    description = "SDK for Niko Home Control";
    homepage = "https://github.com/vandeurenglenn/nhc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
