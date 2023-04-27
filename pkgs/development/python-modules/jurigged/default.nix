{ lib
, buildPythonPackage
, pythonAtLeast
, fetchPypi
, blessed
, codefind
, ovld
, watchdog
, giving
, rich
, hrepr
}:

buildPythonPackage rec {
  pname = "jurigged";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hcVGI2rfTByveIb7bkuLfZ8Ifuz+3GtxaVRESU195v8=";
  };

  propagatedBuildInputs = [
    blessed
    codefind
    ovld
    watchdog
    giving
    rich
    hrepr
  ];

  meta = with lib; {
    description = "Hot reloading for Python";
    homepage = "https://github.com/breuleux/jurigged";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
