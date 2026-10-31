{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  cyclopts,
  matplotlib,
  numpy,
  pillow,
  pooch,
  pyobjc-framework-Cocoa,
  pyvista-validation,
  scooby,
  setuptools,
  typing-extensions,
  vtk,
}:

buildPythonPackage rec {
  pname = "pyvista";
  version = "0.49.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyvista";
    repo = "pyvista";
    tag = "v${version}";
    hash = "sha256-djX8p9k+jHA1qDwDT3hQBuubAUaNr96vaqmay+wo8q8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cyclopts
    matplotlib
    numpy
    pillow
    pooch
    pyvista-validation
    scooby
    typing-extensions
    vtk
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    pyobjc-framework-Cocoa
  ];

  # Fatal Python error: Aborted
  doCheck = false;

  pythonImportsCheck = [ "pyvista" ];

  meta = {
    description = "Easier Pythonic interface to VTK";
    homepage = "https://pyvista.org";
    changelog = "https://github.com/pyvista/pyvista/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
