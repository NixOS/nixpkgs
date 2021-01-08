{ lib, marshmallow
, buildPythonPackage, fetchPypi
, dateutil, simplejson, isPy27, pytest
, pytz
}:

marshmallow.overrideAttrs (_: rec {
  version = "2.21.0";
  src = fetchPypi {
    pname = "marshmallow";
    inherit version;
    sha256 = "6TkMDIBDfXoC2E49FjXcIPN6i8sUnKRD2TeRvcaD8o0=";
  };
})
