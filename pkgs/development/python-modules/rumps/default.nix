{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pyobjc-framework-Cocoa,
  setuptools,
}:

buildPythonPackage {
  pname = "rumps";
  version = "unstable-2025-02-02";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaredks";
    repo = "rumps";
    rev = "8730e7cff5768dfabecff478c0d5e3688862c1c6";
    hash = "sha256-oNJBpRaCGyOKCgBueRx4YhpNW1OnbIEWEEvlGfyoxUA=";
  };

  build-system = [ setuptools ];
  dependencies = [ pyobjc-framework-Cocoa ];

  pythonImportsCheck = [ "rumps" ];

<<<<<<< HEAD
  meta = {
    description = "Ridiculously Uncomplicated macOS Python Statusbar apps";
    homepage = "https://github.com/jaredks/rumps";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ samuela ];
=======
  meta = with lib; {
    description = "Ridiculously Uncomplicated macOS Python Statusbar apps";
    homepage = "https://github.com/jaredks/rumps";
    license = licenses.bsd2;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ samuela ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
