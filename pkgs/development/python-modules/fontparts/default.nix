{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  fonttools,
  defcon,
  fontmath,
  booleanoperations,

  # tests
  python,
}:

buildPythonPackage rec {
  pname = "fontparts";
  version = "0.13.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+oifxmY7MUkQj3Sy75wjRmoVEPkgZaO3+8/sauMMxYA=";
    extension = "zip";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    booleanoperations
    defcon
    fontmath
    fonttools
  ]
  ++ defcon.optional-dependencies.pens
  ++ fonttools.optional-dependencies.ufo
  ++ fonttools.optional-dependencies.lxml
  ++ fonttools.optional-dependencies.unicode;

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} Lib/fontParts/fontshell/test.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "API for interacting with the parts of fonts during the font development process";
    homepage = "https://github.com/robotools/fontParts";
    changelog = "https://github.com/robotools/fontParts/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
