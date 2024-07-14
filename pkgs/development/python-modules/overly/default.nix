{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  h11,
  sansio-multipart,
}:

buildPythonPackage rec {
  pname = "overly";
  version = "0.1.85";

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IKmVJseFmsyFnoev2XtcSRZAXnR3g09ye0khDkeDcMs=";
  };

  propagatedBuildInputs = [
    h11
    sansio-multipart
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "overly" ];

  meta = {
    description = "Overly configurable http server for client testing";
    homepage = "https://github.com/theelous3/overly";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
    broken = stdenv.isDarwin; # https://github.com/theelous3/overly/issues/2
  };
}
