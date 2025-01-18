{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  pillow,
  nix-update-script,
}:
buildPythonPackage rec {
  pname = "basic-colormath";
  version = "0.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "basic_colormath";
    hash = "sha256-p/uNuNg5kqKIkeMmX5sWY8umGAg0E4/otgQxhzIuo0E=";
  };

  propagatedBuildInputs = [ pillow ];

  nativeBuildInputs = [ setuptools-scm ];

  build-system = [ setuptools ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple color conversion and perceptual (DeltaE CIE 2000) difference";
    homepage = "https://github.com/ShayHill/basic_colormath";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anomalocaris ];
  };
}
