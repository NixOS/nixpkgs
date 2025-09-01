{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
}:

buildPythonPackage rec {
  pname = "plotext";
  version = "5.3.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "piccolomo";
    repo = "plotext";
    tag = version;
    hash = "sha256-4cuStXnZFTlOoBp9w+LrTZavCWEaQdZMY4apGNKvBXE=";
  };

  # Package does not have a conventional test suite that can be run with either
  # `pytestCheckHook` or the standard setuptools testing situation.
  doCheck = false;

  pythonImportsCheck = [ "plotext" ];

  meta = with lib; {
    description = "Plotting directly in the terminal";
    mainProgram = "plotext";
    homepage = "https://github.com/piccolomo/plotext";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
