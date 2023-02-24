{ lib, fetchPypi, buildPythonPackage, pytest }:

buildPythonPackage rec {
  version = "0.9.0";
  pname = "node-semver";

  nativeCheckInputs = [ pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BKoLABbbwGdI1jeMQtjPgqNDQVvZ/KYoT0iAQdCLM7s=";
  };

  meta = with lib; {
    homepage = "https://github.com/podhmo/python-semver";
    description = "A port of node-semver";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
