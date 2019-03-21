{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, jinja2
, matplotlib
, numpy
, requests
, six
}:

buildPythonPackage rec {
  version = "1.2.1";
  pname = "lightning-python";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3987d7d4a634bdb6db9bcf212cf4d2f72bab5bc039f4f6cbc02c9d01c4ade792";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ jinja2 matplotlib numpy requests six ];

  meta = with stdenv.lib; {
    description = "A Python client library for the Lightning data visualization server";
    homepage = http://lightning-viz.org;
    license = licenses.mit;
  };

}
