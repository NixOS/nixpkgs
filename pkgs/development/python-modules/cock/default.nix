{ lib, buildPythonPackage, fetchPypi, locale, pytestCheckHook, click, sortedcontainers, pyyaml }:

buildPythonPackage rec {
  pname = "cock";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gwaklvwlyvhz2c07hdmhbnqqmpybssxzzr0399dpjk7dgdqgam3";
  };

  propagatedBuildInputs = [ click sortedcontainers pyyaml ];

  meta = with lib; {
    homepage = "https://github.com/pohmelie/cock";
    description = "Configuration file with click";
    license = licenses.mit;
  };
}
