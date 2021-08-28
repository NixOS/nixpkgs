{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "hpack";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fc41de0c63e687ebffde81187a948221294896f6bdc0ae2312708df339430095";
  };

  meta = with lib; {
    description = "Pure-Python HPACK header compression";
    homepage = "http://hyper.rtfd.org";
    license = licenses.mit;
  };

}
