{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "pyinstrument";
  version = "5.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "joerick";
    repo = "pyinstrument";
    tag = "v${version}";
    hash = "sha256-t1kiHqzaJDnjdsHBLEcWHSxPM6jZ7rPctFCjDQpL8ks=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  # Module import recursion
  doCheck = false;

  pythonImportsCheck = [ "pyinstrument" ];

  meta = with lib; {
    description = "Call stack profiler for Python";
    mainProgram = "pyinstrument";
    homepage = "https://github.com/joerick/pyinstrument";
    changelog = "https://github.com/joerick/pyinstrument/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
