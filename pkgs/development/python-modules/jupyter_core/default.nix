{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, hatchling
, traitlets
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jupyter_core";
  version = "4.11.2";
  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jupyter";
    repo = "jupyter_core";
    rev = version;
    hash = "sha256-lDhwvhsOxLHBC6CQjCW/rmtHSuMRPC2yaurBd5K3FLc=";
  };

  patches = [
    ./tests_respect_pythonpath.patch
  ];

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    traitlets
  ];

  checkInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests = [
    # creates a temporary script, which isn't aware of PYTHONPATH
    "test_argv0"
  ];

  postCheck = ''
    $out/bin/jupyter --help > /dev/null
  '';

  pythonImportsCheck = [ "jupyter_core" ];

  meta = with lib; {
    description = "Base package on which Jupyter projects rely";
    homepage = "https://jupyter.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}
