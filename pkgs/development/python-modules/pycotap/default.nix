{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pycotap";
  version = "1.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Z0NV8BMAvgPff4cXhOSYZSwtiawZzXfujmFlJjSi+Do=";
  };

  meta = {
    description = "Test runner for unittest that outputs TAP results to stdout";
    homepage = "https://el-tramo.be/pycotap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mwolfe ];
  };
}
