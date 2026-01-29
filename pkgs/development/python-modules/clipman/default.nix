{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  dbus-next,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "clipman";
  version = "3.3.3";
  src = fetchFromGitHub {
    owner = "NikitaBeloglazov";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-m50yxbbMBLooVQD1QYQi6QekaiQlzTHXSJIMdU+/+Rw=";
  };
  format = "pyproject";
  propagatedBuildInputs = [
    dbus-next
  ];
  nativeBuildInputs = [
    setuptools-scm
  ];
  pythonImportsCheck = [
    "clipman"
  ];

  meta = with lib; {
    homepage = "https://github.com/NikitaBeloglazov/clipman";
    description = "Python3 module for working with clipboard. Created because pyperclip is discontinued";
    license = licenses.mpl20;
    maintainers = with maintainers; [ Freed-Wu ];
    platforms = platforms.unix;
  };
}
