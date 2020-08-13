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
  version = "2.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aadc23f0ae2eaa75868e4359f1ea7d75ff46bc8cb1988651f3f3fd5d4ec44679";
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
