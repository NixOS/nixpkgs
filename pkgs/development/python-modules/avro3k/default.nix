{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "avro3k";
  version = "1.7.7-SNAPSHOT";
  pyproject = true;
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "15ahl0irwwj558s964abdxg4vp6iwlabri7klsm2am6q5r0ngsky";
  };

  # setuptools.extern.packaging.version.InvalidVersion: Invalid version: '1.7.7-SNAPSHOT'
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "1.7.7-SNAPSHOT" "1.7.7"
  '';

  build-system = [ setuptools ];

  doCheck = false; # No such file or directory: './run_tests.py

  meta = with lib; {
    description = "Serialization and RPC framework";
    mainProgram = "avro";
    homepage = "https://pypi.python.org/pypi/avro3k/";
  };
}
