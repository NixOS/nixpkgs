{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch
, hatchling
, platformdirs
, traitlets
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jupyter-core";
  version = "5.2.0";
  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jupyter";
    repo = "jupyter_core";
    rev = "refs/tags/v${version}";
    hash = "sha256-X3P3bTLhpWIa6EHdxZ/KFiQNAnhszha2cfZ8PynZPRs=";
  };

  patches = [
    ./tests_respect_pythonpath.patch
    (fetchpatch {
      # add support for platformdirs>=3
      url = "https://github.com/jupyter/jupyter_core/commit/ff4086cdbdac2ea79c18632e4e35acebc1f7cf57.patch";
      hash = "sha256-UhHO58xZ4hH47NBhOhsfBjgsUtA+1EIHxPBvnKA5w28=";
    })
  ];

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    platformdirs
    traitlets
  ];

  nativeCheckInputs = [
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
