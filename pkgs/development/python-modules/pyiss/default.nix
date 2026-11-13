{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  voluptuous,
  httmock,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyiss";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "HydrelioxGitHub";
    repo = "pyiss";
    tag = version;
    hash = "sha256-bhxeu/06B6ba9RB9p++tRWN/Dp3KUel9DN166HryP1E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    voluptuous
  ];

  nativeCheckInputs = [
    httmock
    unittestCheckHook
  ];

  pythonImportsCheck = [ "pyiss" ];

  meta = {
    description = "Python library to access International Space Station location and data";
    homepage = "https://github.com/HydrelioxGitHub/pyiss";
    changelog = "https://github.com/HydrelioxGitHub/pyiss/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
