{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage {
  pname = "cprint";
  version = "1.2.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "EVasseure";
    repo = "cprint";
    rev = "cae3fdce19c82608b426a6371c057f7d1c39ea6f";
    hash = "sha256-JimZFYLeXCkGNkNijSTPEyjTkV+W4supe7RVEzKNsuk=";
  };

  pythonImportsCheck = [ "cprint" ];

  meta = {
    description = "Printing and debugging with color";
    homepage = "https://github.com/EVasseure/cprint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stacksparrow4 ];
  };
}
