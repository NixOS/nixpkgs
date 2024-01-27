{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "mpyq";
  version = "0.2.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01q0xh2fy3zzsrfr45d2ypj4whs7s060cy1rnprg6sg55fbgbaih";
  };

  meta = {
    description = "A Python library for extracting MPQ (MoPaQ) files.";
    homepage = "https://github.com/eagleflo/mpyq";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ];
  };
}
