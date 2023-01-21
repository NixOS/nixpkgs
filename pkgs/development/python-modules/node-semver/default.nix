{ lib, fetchPypi, buildPythonPackage, pytest }:

buildPythonPackage rec {
  version = "0.8.1";
  pname = "node-semver";

  nativeCheckInputs = [ pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "281600d009606f4f63ddcbe148992e235b39a69937b9c20359e2f4a2adbb1e00";
  };

  meta = with lib; {
    homepage = "https://github.com/podhmo/python-semver";
    description = "A port of node-semver";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
