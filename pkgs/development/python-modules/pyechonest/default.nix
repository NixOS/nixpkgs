{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "pyechonest";
  version = "9.0.0";
  format = "setuptools";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1da4b3b8b457232a7eb35b59a48390b3c208759b01d596acaa71e6a172b40495";
  };

  meta = with lib; {
    description = "Tap into The Echo Nest's Musical Brain for the best music search, information, recommendations and remix tools on the web";
    homepage = "https://github.com/echonest/pyechonest";
  };
}
