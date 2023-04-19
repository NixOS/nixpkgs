{ lib
, buildPythonPackage
, click
, cloudpickle
, dask
, fetchPypi
, jinja2
, locket
, msgpack
, packaging
, psutil
, pythonOlder
, pyyaml
, sortedcontainers
, tblib
, toolz
, tornado
, urllib3
, zict
}:

buildPythonPackage rec {
  pname = "distributed";
  version = "2023.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E0eks6HlJzZy/XqHRxQJ4brEcLS9tniMkYMT1FoikRs=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "tornado >= 6.0.3, <6.2" "tornado >= 6.0.3"
  '';

  propagatedBuildInputs = [
    click
    cloudpickle
    dask
    jinja2
    locket
    msgpack
    packaging
    psutil
    pyyaml
    sortedcontainers
    tblib
    toolz
    tornado
    urllib3
    zict
  ];

  # When tested random tests would fail and not repeatably
  doCheck = false;

  pythonImportsCheck = [
    "distributed"
  ];

  meta = with lib; {
    description = "Distributed computation in Python";
    homepage = "https://distributed.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh costrouc ];
  };
}
