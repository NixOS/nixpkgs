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
  version = "5.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "joerick";
    repo = "pyinstrument";
    tag = "v${version}";
    hash = "sha256-30e8J7TF16SRgDTt5Eizc7ofg00bCF61O9y+2jA63GY=";
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
