{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, hatchling
, platformdirs
, traitlets
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jupyter-core";
  version = "5.1.1";
  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jupyter";
    repo = "jupyter_core";
    rev = "refs/tags/v${version}";
    hash = "sha256-54zbo+RXgT9AJabmJYHCznyoinTQqrTORzlM48WpnQQ=";
  };

  patches = [
    ./tests_respect_pythonpath.patch
  ];

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    platformdirs
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
