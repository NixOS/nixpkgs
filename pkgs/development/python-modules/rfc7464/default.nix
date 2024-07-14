{
  buildPythonPackage,
  fetchPypi,
  lib,
}:

buildPythonPackage rec {
  pname = "rfc7464";
  version = "17.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6sxI8jVnCJAXucrjJYCYJswAMiqaiTRwZY5ejAY0lsE=";
    extension = "zip";
  };

  meta = with lib; {
    homepage = "https://github.com/moshez/rfc7464";
    description = "RFC 7464 is a proposed standard for streaming JSON documents";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ shlevy ];
  };
}
