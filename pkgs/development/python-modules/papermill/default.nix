{ lib
, buildPythonPackage
, fetchPypi
, ansiwrap
, click
, future
, pyyaml
, nbformat
, nbconvert
, six
, tqdm
, jupyter_client
, requests
, entrypoints
, tenacity
, futures
, backports_tempfile
, isPy27
, pytest
, pytestcov
, pytest-mock
}:

buildPythonPackage rec {
  pname = "papermill";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04dadaabdeb129c7414079f77b9f9a4a08f1322549aa99e20e4a12700ee23509";
  };

  propagatedBuildInputs = [
    ansiwrap
    click
    future
    pyyaml
    nbformat
    nbconvert
    six
    tqdm
    jupyter_client
    requests
    entrypoints
    tenacity
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
    homepage = https://github.com/nteract/papermill;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
