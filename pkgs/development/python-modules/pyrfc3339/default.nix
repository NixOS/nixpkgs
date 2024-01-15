{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# build-system
, setuptools

# dependencies
, pytz

# tests
, nose
}:

buildPythonPackage rec {
  pname = "pyRFC3339";
  version = "1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "06jv7ar7lpvvk0dixzwdr3wgm0g1lipxs429s2z7knwwa7hwpf41";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pytz
  ];

  doCheck = pythonOlder "3.12";

  nativeCheckInputs = [
    nose
  ];

  meta = with lib; {
    description = "Generate and parse RFC 3339 timestamps";
    homepage = "https://github.com/kurtraschke/pyRFC3339";
    license = licenses.mit;
  };

}
