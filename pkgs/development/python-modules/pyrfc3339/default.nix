{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  pytz,

  # tests
  nose,
}:

buildPythonPackage rec {
  pname = "pyrfc3339";
  version = "1.1";
  pyproject = true;

  src = fetchPypi {
    pname = "pyRFC3339";
    inherit version;
    sha256 = "06jv7ar7lpvvk0dixzwdr3wgm0g1lipxs429s2z7knwwa7hwpf41";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ pytz ];

  doCheck = pythonOlder "3.12";

  nativeCheckInputs = [ nose ];

  meta = with lib; {
    description = "Generate and parse RFC 3339 timestamps";
    homepage = "https://github.com/kurtraschke/pyRFC3339";
    license = licenses.mit;
  };
}
