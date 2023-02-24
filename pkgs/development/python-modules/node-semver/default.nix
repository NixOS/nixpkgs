{ lib
, fetchPypi
, buildPythonPackage
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "node-semver";
  version = "0.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  nativeCheckInputs = [ pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BKoLABbbwGdI1jeMQtjPgqNDQVvZ/KYoT0iAQdCLM7s=";
  };

  meta = with lib; {
    changelog = "https://github.com/podhmo/python-node-semver/blob/${version}/CHANGES.txt";
    homepage = "https://github.com/podhmo/python-semver";
    description = "A port of node-semver";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
