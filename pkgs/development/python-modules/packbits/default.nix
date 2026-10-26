{
  buildPythonPackage,
  fetchPypi,
  lib,
}:

buildPythonPackage (finalAttrs: {
  pname = "packbits";
  version = "0.6";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-vGs3C7NOBKyM+oNeBsBIQ4Cv/G1ZOtuACd1sD3v/8DQ=";
  };

  meta = {
    description = "PackBits encoder/decoder for Python";
    homepage = "https://github.com/psd-tools/packbits";
    license = lib.licenses.mit;
  };
})
