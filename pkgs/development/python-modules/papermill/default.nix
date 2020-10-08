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
, jupyter_client
, requests
, entrypoints
, tenacity
, futures
, black
, backports_tempfile
, isPy27
, pytest
, pytestcov
, pytest-mock
}:

buildPythonPackage rec {
  pname = "papermill";
  version = "2.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ecd4cafa9179693b0eedc3b6f4560f9ee47826a6e366e42bfa3cc20f7931b3f8";
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
    jupyter_client
    requests
    entrypoints
    tenacity
    black
  ] ++ lib.optionals isPy27 [
    futures
    backports_tempfile
  ];

  checkInputs = [
    pytest
    pytestcov
    pytest-mock
  ];

  checkPhase = ''
    HOME=$(mktemp -d) pytest
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
