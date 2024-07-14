{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyparsing,
}:
buildPythonPackage rec {
  pname = "pylibconfig2";
  version = "0.2.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GGvS2INWA2rIdwGVyKPpusPM2zuebs8EvmLDB3YIlcc=";
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
