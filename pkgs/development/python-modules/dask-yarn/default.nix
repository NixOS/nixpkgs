{ lib
, stdenv
, buildPythonPackage
, dask
, distributed
, fetchFromGitHub
, grpcio
, pytestCheckHook
, pythonOlder
, skein
}:

buildPythonPackage rec {
  pname = "dask-yarn";
  version = "0.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = version;
    hash = "sha256-/BTsxQSiVQrihrCa9DE7pueyg3aPAdjd/Dt4dpUwdtM=";
  };

  propagatedBuildInputs = [
    distributed
    dask
    grpcio
    skein
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [
    "dask_yarn"
  ];

  disabledTests = [
    # skein.exceptions.DriverError: Failed to start java process
    "test_basic"
    "test_adapt"
    "test_from_specification"
    "test_from_application_id"
    "test_from_current"
    "test_basic_async"
    "test_widget_and_html_reprs"
  ];

  meta = with lib; {
    description = "Deploy dask on YARN clusters";
    longDescription = ''Dask-Yarn deploys Dask on YARN clusters,
      such as are found in traditional Hadoop installations.
      Dask-Yarn provides an easy interface to quickly start,
      stop, and scale Dask clusters natively from Python.
    '';
    homepage = "https://yarn.dask.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ illustris ];
    broken = stdenv.isDarwin;
  };
}
