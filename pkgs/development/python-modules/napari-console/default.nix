{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ipykernel,
  ipython,
  pythonOlder,
  qtconsole,
  qtpy,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "napari-console";
  version = "0.0.9";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "napari";
    repo = "napari-console";
    rev = "refs/tags/v${version}";
    hash = "sha256-3gOfiPx06G5c4eaLQ5kP45hUr6yw91esznJFacpO66Q=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    ipykernel
    ipython
    qtconsole
    qtpy
  ];

  # Circular dependency: napari
  doCheck = false;

  pythonImportsCheck = [ "napari_console" ];

  meta = with lib; {
    description = "Plugin that adds a console to napari";
    homepage = "https://github.com/napari/napari-console";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
