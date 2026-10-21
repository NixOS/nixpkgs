{
  buildPythonPackage,
  fetchPypi,
  lib,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "rfc7464";
  version = "17.7.0";
  format = "setuptools";

  # AttributeError: module 'configparser' has no attribute 'SafeConfigParser'. Did you mean: 'RawConfigParser'?
  disabled = pythonAtLeast "3.12";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6sxI8jVnCJAXucrjJYCYJswAMiqaiTRwZY5ejAY0lsE=";
    extension = "zip";
  };

  meta = {
    homepage = "https://github.com/moshez/rfc7464";
    description = "RFC 7464 is a proposed standard for streaming JSON documents";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shlevy ];
  };
}
