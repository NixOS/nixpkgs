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
  version = "4.7.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "joerick";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Dvpx6Bf4obHL3inzIHhOrM3u/7X+0NRfEAyynDjtEwE=";
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
    changelog = "https://github.com/joerick/pyinstrument/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
