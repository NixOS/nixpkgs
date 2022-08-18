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
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-b4+KmwazlnfyB8CRAMjThrz1kvDLvdqfD1DoFEVpdic=";
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
