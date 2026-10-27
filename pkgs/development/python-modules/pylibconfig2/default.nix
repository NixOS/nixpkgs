{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyparsing,
}:
buildPythonPackage (finalAttrs: {
  pname = "pylibconfig2";
  version = "0.2.5";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-GGvS2INWA2rIdwGVyKPpusPM2zuebs8EvmLDB3YIlcc=";
  };

  # tests not included in the distribution
  doCheck = false;

  propagatedBuildInputs = [ pyparsing ];

  meta = {
    homepage = "https://github.com/heinzK1X/pylibconfig2";
    description = "Pure python library for libconfig syntax";
    license = lib.licenses.gpl3;
  };
})
