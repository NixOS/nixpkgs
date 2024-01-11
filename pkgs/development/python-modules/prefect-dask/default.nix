{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, coverage
, distributed
, mock
, prefect
, dask
}:



buildPythonPackage rec {

  pname = "prefect-dask";
  version = "0.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MjY13K/K8mmBORnHUhUrVIPj/XKwozOnd/UnWRLiWrk=";
  };

  propagatedBuildInputs = [
    prefect
    mock
    distributed
    coverage
    dask
  ];

  # tests require a database
  doCheck = false;

  pythonImportsCheck = [ "prefect_dask" ];

  meta = with lib; {
    description = "Prefect integrations with the Dask execution framework";
    license = licenses.asl20;
    maintainers = with maintainers; [ nviets ];
  };

}
