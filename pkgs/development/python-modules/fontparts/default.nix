{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch2,
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
  version = "0.12.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-d41ZVJOiCPITRjgGajBZh2JhnV345yPTCiTEGJzPoQ0=";
    extension = "zip";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies =
    [
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
