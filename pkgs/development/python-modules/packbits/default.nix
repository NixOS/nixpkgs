{ stdenv
, buildPythonPackage
, fetchPypi
, pyparsing
, six
, pytest
, pretend
, lib
}:

buildPythonPackage rec {
  pname = "packbits";
  version = "0.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bc6b370bb34e04ac8cfa835e06c0484380affc6d593adb8009dd6c0f7bfff034";
  };

  meta = with lib; {
    description = "PackBits encoder/decoder for Python";
    homepage = "https://github.com/psd-tools/packbits";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ grahamc ];
  };
}
