{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, hatchling
, platformdirs
, traitlets
, pip
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jupyter-core";
  version = "5.7.2";
  disabled = pythonOlder "3.7";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyter";
    repo = "jupyter_core";
    rev = "refs/tags/v${version}";
    hash = "sha256-qu25ryZreRPHoubFJTFusGdkTPHbl/yl94g+XU5A5Mc=";
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

  nativeCheckInputs = [
    pip
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  pytestFlagsArray = [
    # suppress pytest.PytestUnraisableExceptionWarning: Exception ignored in: <socket.socket fd=-1, family=AddressFamily.AF_UNIX, type=SocketKind.SOCK_STREAM, proto=0>
    "-W ignore::pytest.PytestUnraisableExceptionWarning"
  ];

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
    changelog = "https://github.com/jupyter/jupyter_core/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = teams.jupyter.members;
  };
}
