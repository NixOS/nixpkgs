{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  click,
  pytest,
}:

buildPythonPackage (finalAttrs: {
  pname = "cligj";
  version = "0.7.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "cligj";
    tag = finalAttrs.version;
    hash = "sha256-0f9+I6ozX93Vn0l7+WR0mpddDZymJQ3+Krovt6co22Y=";
  };

  build-system = [ setuptools ];

  dependencies = [ click ];

  nativeCheckInputs = [
    pytest
  ];

  checkPhase = ''
    pytest tests
  '';

  pythonImportsCheck = [ "cligj" ];

  meta = {
    description = "Click params for command line interfaces to GeoJSON";
    homepage = "https://github.com/mapbox/cligj";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
