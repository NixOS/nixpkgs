{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  version = "1.11.2";
  pname = "robotframework-datadriver";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "robotframework_datadriver"; # the package file has an underscore instead of a dash
    sha256 = "sha256-x1o7iFbhQTMeZaIqa+0agmMiHuba2CHVJvkykYV2//0=";
  };

  meta = with lib; {
    description = "Library to provide Data-Driven testing with CSV tables to Robot Framework";
    homepage = "https://github.com/Snooz82/robotframework-datadriver/";
    license = licenses.asl20;
    maintainers = with maintainers; [ tobiasBora ];
  };

}
