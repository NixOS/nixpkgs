{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  versioneer,
  dask,
  distributed,
  grpcio,
  skein,
  pytestCheckHook,
  stdenv,
}:

buildPythonPackage rec {
  pname = "dask-yarn";
  version = "0.9";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dask";
    repo = "dask-yarn";
    rev = "refs/tags/${version}";
    hash = "sha256-/BTsxQSiVQrihrCa9DE7pueyg3aPAdjd/Dt4dpUwdtM=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/dask/dask-yarn/pull/150
      name = "address-deprecations-introduced-in-distributed-2021-07-0";
      url = "https://github.com/dask/dask-yarn/pull/150/commits/459848afcdc22568905ee98622c74e4071496423.patch";
      hash = "sha256-LS46QBdiAmsp4jQq4DdYdmmk1qzx5JZNTQUlRcRwY5k=";
    })
  ];

  postPatch = ''
    rm versioneer.py
  '';

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [
    dask
    distributed
    grpcio
    skein
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [ "dask_yarn" ];

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
    mainProgram = "dask-yarn";
    longDescription = ''
      Dask-Yarn deploys Dask on YARN clusters,
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
