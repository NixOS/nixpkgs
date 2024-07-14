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
    hash = "sha256-gbjL4VGc23m+0EkQ3W+k4YH6+MiN/x4bmHtferI6Wxo=";
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
