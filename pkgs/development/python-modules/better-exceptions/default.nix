{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "better-exceptions";
  version = "0.3.3";
  format = "setuptools";

  doCheck = false;

  src = fetchPypi {
    pname = "better_exceptions";
    inherit version;
    hash = "sha256-5Oa8GERNXwTm6JSxA4Hl6SHT1UQkBBgWLH21fp6zRTs=";
  };

  meta = with lib; {
    description = "Pretty and more helpful exceptions in Python, automatically.";
    homepage = "https://github.com/qix-/better-exceptions";
    license = licenses.mit;
  };
}
