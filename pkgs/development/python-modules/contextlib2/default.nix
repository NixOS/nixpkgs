{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
  unittestCheckHook,
}:

buildPythonPackage {
  pname = "contextlib2";
  version = "21.6.0-unstable-2024-05-23";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "contextlib2";
    rev = "f64cf04df8a1f6a32ce2095192b4638d229ff25e";
    hash = "sha256-HX9N8G8jl6cpEwdJ80pDcoo4osTO/f8fz5sNcY/R1Nk=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "contextlib2" ];

  meta = {
    description = "Backports and enhancements for the contextlib module";
    homepage = "https://contextlib2.readthedocs.org/";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
