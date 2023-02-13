{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, dufte
, matplotlib
, numpy
, pipdate
, tqdm
, rich
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "perfplot";
  version = "0.10.2";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nschloe";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-bu6eYQukhLE8sLkS3PbqTgXOqJFXJYXTcXAhmjaq48g=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    dufte
    matplotlib
    numpy
    pipdate
    rich
    tqdm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "perfplot" ];

  meta = with lib; {
    description = "Performance plots for Python code snippets";
    homepage = "https://github.com/nschloe/perfplot";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
    broken = true; # missing matplotx dependency
  };
}
