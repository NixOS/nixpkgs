{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, distributed
, dask
, grpcio
, skein
}:

buildPythonPackage rec {
  pname = "dask-yarn";
  version = "0.9";

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

  checkInputs = [ pytestCheckHook ];
  preCheck = ''
    export HOME=$TMPDIR
  '';
  pythonImportsCheck = [ "dask_yarn" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Deploy dask on YARN clusters";
    longDescription = ''Dask-Yarn deploys Dask on YARN clusters,
      such as are found in traditional Hadoop installations.
      Dask-Yarn provides an easy interface to quickly start,
      stop, and scale Dask clusters natively from Python.
    '';
    homepage = "https://yarn.dask.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ illustris ];
  };
}
