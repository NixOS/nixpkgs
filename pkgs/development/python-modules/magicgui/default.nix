{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, pytestCheckHook
, pytest-mypy-plugins
, typing-extensions
, qtpy
, pyside2
, psygnal
, docstring-parser
, napari # a reverse-dependency, for tests
}: buildPythonPackage rec {
  pname = "magicgui";
  version = "0.5.1";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "napari";
    repo = "magicgui";
    rev = "refs/tags/v${version}";
    hash = "sha256-fVfBQaaT8/lUGqZRXjOPgvkC01Izb8Sxqn7RCqnW9bo=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ typing-extensions qtpy pyside2 psygnal docstring-parser ];
  nativeCheckInputs = [ pytestCheckHook pytest-mypy-plugins ];

  doCheck = false; # Reports "Fatal Python error"

  passthru.tests = { inherit napari; };

  meta = with lib; {
    description = "Build GUIs from python functions, using magic.  (napari/magicgui)";
    homepage = "https://github.com/napari/magicgui";
    license = licenses.mit;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
