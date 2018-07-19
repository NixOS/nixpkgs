{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "invoke";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0aiy1xvk1f91246zxd1zqrm679vdvd10h843a2na41cqr3cflpi6";
  };

  # errors with vendored libs
  doCheck = false;

  meta = {
    description = "Pythonic task execution";
    license = lib.licenses.bsd2;
  };
}
