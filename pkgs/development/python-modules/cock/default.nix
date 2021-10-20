{ lib, buildPythonPackage, fetchPypi, locale, pytestCheckHook, click, sortedcontainers, pyyaml }:

buildPythonPackage rec {
  pname = "cock";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d9021c2d9ce0dbf495a3c5ef960a9996a0681bb96ff6099f37302a3813a184e";
  };

  propagatedBuildInputs = [ click sortedcontainers pyyaml ];

  meta = with lib; {
    homepage = "https://github.com/pohmelie/cock";
    description = "Configuration file with click";
    license = licenses.mit;
  };
}
