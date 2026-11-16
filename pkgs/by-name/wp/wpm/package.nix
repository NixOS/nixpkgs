{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "wpm";
  version = "1.51.5";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-swT9E5Tto4yWnm0voowcJXtY3cIY3MNqAdfrTnuGbdg=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    setuptools # pkg_resources is imported during runtime
  ];

  pythonImportsCheck = [ "wpm" ];

  meta = {
    description = "Console app for measuring typing speed in words per minute (WPM)";
    mainProgram = "wpm";
    homepage = "https://pypi.org/project/wpm";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ alejandrosame ];
  };
})
