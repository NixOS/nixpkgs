{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "multipledispatch";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e92d63efad2c9b68562175d9148d8cb32d04bf5557991190e643749bf4ed954";
  };

  # No tests in archive
  doCheck = false;

  meta = {
    homepage = https://github.com/mrocklin/multipledispatch/;
    description = "A relatively sane approach to multiple dispatch in Python";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}