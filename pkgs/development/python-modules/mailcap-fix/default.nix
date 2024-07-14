{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "mailcap-fix";
  version = "1.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ETwLNgkawLgYHDPyzUkFKA4bsxY4PTw/yumMbfCUkQo=";
  };

  meta = with lib; {
    description = "Patched mailcap module that conforms to RFC 1524";
    homepage = "https://github.com/michael-lazar/mailcap_fix";
    license = licenses.unlicense;
  };
}
