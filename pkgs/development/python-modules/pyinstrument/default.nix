{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "pyinstrument";
  version = "4.5.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "joerick";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-VL/JzgMxn5zABfmol+5oofR1RjyxTdzvUi6JnwsSFao=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  # Module import recursion
  doCheck = false;

  pythonImportsCheck = [
    "pyinstrument"
  ];

  meta = with lib; {
    description = "Call stack profiler for Python";
    homepage = "https://github.com/joerick/pyinstrument";
    changelog = "https://github.com/joerick/pyinstrument/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
