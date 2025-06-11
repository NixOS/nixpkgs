{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "wpm";
  version = "1.51.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-swT9E5Tto4yWnm0voowcJXtY3cIY3MNqAdfrTnuGbdg=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
  ];

  pythonImportsCheck = [ "wpm" ];

  meta = with lib; {
    description = "Console app for measuring typing speed in words per minute (WPM)";
    mainProgram = "wpm";
    homepage = "https://pypi.org/project/wpm";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ alejandrosame ];
  };
}
