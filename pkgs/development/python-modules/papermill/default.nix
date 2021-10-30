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
, black
, backports_tempfile
, isPy27
, pytest
, pytest-cov
, pytest-mock
}:

buildPythonPackage rec {
  pname = "papermill";
  version = "2.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "349aecd526c15c39f73a08df836467e2fead877c474d82c7df349f27ad272525";
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
    black
  ] ++ lib.optionals isPy27 [
    futures
    backports_tempfile
  ];

  checkInputs = [
    pytest
    pytest-cov
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
