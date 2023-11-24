{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, flit-core
, matplotlib
, matplotx
, numpy
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
    hash = "sha256-bu6eYQukhLE8sLkS3PbqTgXOqJFXJYXTcXAhmjaq48g=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    matplotlib
    matplotx
    numpy
    rich
  ];

  # This variable is needed to suppress the "Trace/BPT trap: 5" error in Darwin's checkPhase.
  # Not sure of the details, but we can avoid it by changing the matplotlib backend during testing.
  env.MPLBACKEND = lib.optionalString stdenv.isDarwin "Agg";

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "perfplot"
  ];

  meta = with lib; {
    description = "Performance plots for Python code snippets";
    homepage = "https://github.com/nschloe/perfplot";
    changelog = "https://github.com/nschloe/perfplot/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
