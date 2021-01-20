{ lib, fetchPypi, buildPythonPackage, requests, zeroconf, protobuf, casttube, isPy3k }:

buildPythonPackage rec {
  pname = "PyChromecast";
  version = "7.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w7jayb0z529bh1ybb16pfm0m08qqi4px1q0qwlvcxlcrd2v3m5a";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ requests zeroconf protobuf casttube ];

  # no tests available
  doCheck = false;
  pythonImportsCheck = [ "pychromecast" ];

  meta = with lib; {
    description = "Library for Python to communicate with the Google Chromecast";
    homepage    = "https://github.com/home-assistant-libs/pychromecast";
    license     = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
    platforms   = platforms.unix;
  };
}
