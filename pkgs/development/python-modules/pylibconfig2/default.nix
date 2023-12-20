{ lib, buildPythonPackage, fetchPypi, pyparsing }:
buildPythonPackage rec {
  pname = "pylibconfig2";
  version = "0.2.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1iwm11v0ghv2pq2cyvly7gdwrhxsx6iwi581fz46l0snhgcd4sqq";
  };

  # tests not included in the distribution
  doCheck = false;

  propagatedBuildInputs = [ pyparsing ];

  meta = with lib; {
    homepage = "https://github.com/heinzK1X/pylibconfig2";
    description = "Pure python library for libconfig syntax";
    license = licenses.gpl3;
  };
}
