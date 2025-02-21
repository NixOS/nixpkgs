{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pyqtgraph,
  numpy,
  pyqt5,
  pyqt6,
  pyside6,
  mypy,
}:

buildPythonPackage rec {
  pname = "pglive";
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "domarm-comat";
    repo = "pglive";
    tag = "v${version}";
    hash = "sha256-/z4hpWqxW4WkHa9SXfu7UXHoNrVpbqR7+YbsRQUuEA8=";
  };

  # Add support for numpy >=2.x
  prePatch = ''
    substituteInPlace pyproject.toml \
      --replace 'numpy = "^1.26.0"' 'numpy = ">=1.26.0"'
  '';

  build-system = [
    poetry-core
  ];

  dependencies = [
    pyqtgraph
    numpy
  ];

  passthru.optional-dependencies = {
    pyqt5 = [ pyqt5 ];
    pyqt6 = [ pyqt6 ];
    pyside6 = [ pyside6 ];
  };

  nativeCheckInputs = [
    mypy
  ];

  # No available tests
  doCheck = false;

  pythonImportsCheck = [ "pglive" ];

  meta = {
    changelog = "https://github.com/domarm-comat/pglive/releases/tag/v${version}";
    description = "Live plot for PyqtGraph";
    homepage = "https://github.com/domarm-comat/pglive";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fsagbuya ];
  };
}
