{
  lib,
  apptools,
  buildPythonPackage,
  fetchFromGitHub,
  pyface,
  pytestCheckHook,
  setuptools,
  traits,
  traitsui,
}:

buildPythonPackage {
  pname = "envisage";
  version = "7.0.4-unstable-2026-07-07";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "enthought";
    repo = "envisage";
    rev = "8b1548a589ff1c317a3a1c709e2d186302e8df88";
    hash = "sha256-EF0FEuKX0TPmb9eOyiF7M3DoLyvxpcq8ePQHxEfg30g=";
  };

  build-system = [ setuptools ];

  dependencies = [
    apptools
    pyface
    setuptools
    traits
    traitsui
  ]
  ++ apptools.optional-dependencies.preferences;

  preCheck = ''
    export HOME=$PWD/HOME
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "envisage" ];

  meta = {
    description = "Framework for building applications whose functionalities can be extended by adding plug-ins";
    homepage = "https://github.com/enthought/envisage";
    license = lib.licenses.bsdOriginal;
    maintainers = [ ];
  };
}
