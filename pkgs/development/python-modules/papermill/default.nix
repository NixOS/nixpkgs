{ lib
, buildPythonPackage
, fetchPypi
, ansiwrap
, click
, future
, pyyaml
, nbformat
, nbconvert
, nbclient
, six
, tqdm
, jupyter-client
, requests
, entrypoints
, tenacity
, futures ? null
, backports_tempfile
, isPy27
, pytestCheckHook
, pytest-mock
}:

buildPythonPackage rec {
  pname = "papermill";
  version = "2.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "be12d2728989c0ae17b42fcb05b623500004e94b34f56bd153355ccebb84a59a";
  };

  propagatedBuildInputs = [
    ansiwrap
    click
    future
    pyyaml
    nbformat
    nbconvert
    nbclient
    six
    tqdm
    jupyter-client
    requests
    entrypoints
    tenacity
  ] ++ lib.optionals isPy27 [
    futures
    backports_tempfile
  ];

  checkInputs = [
    pytestCheckHook
    pytest-mock
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # the test suite depends on cloud resources azure/aws
  doCheck = false;

  meta = with lib; {
    description = "Parametrize and run Jupyter and nteract Notebooks";
    homepage = "https://github.com/nteract/papermill";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
