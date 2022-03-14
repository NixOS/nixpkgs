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
}: buildPythonPackage rec {
  pname = "magicgui";
  version = "0.3.7";
  src = fetchFromGitHub {
    owner = "napari";
    repo = "magicgui";
    rev = "v${version}";
    sha256 = "sha256-LYXNNr5lS3ibQk2NIopZkB8kzC7j3yY8moGMk0Gr+hU=";
  };
  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ typing-extensions qtpy pyside2 psygnal docstring-parser ];
  checkInputs = [ pytestCheckHook pytest-mypy-plugins ];
  doCheck = false; # Reports "Fatal Python error"
  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  meta = with lib; {
    description = "Build GUIs from python functions, using magic.  (napari/magicgui)";
    homepage = "https://github.com/napari/magicgui";
    license = licenses.mit;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
