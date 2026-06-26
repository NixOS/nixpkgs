{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

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

buildPythonPackage (finalAttrs: {
  pname = "fontparts";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robotools";
    repo = "fontParts";
    tag = finalAttrs.version;
    hash = "sha256-dBR9Lf8ECLAOAkEkEy4JCgOKmyXzwXaOXdW4cErWQcs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "vcs-versioning"' ""
  '';

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

  pythonImportsCheck = [ "fontParts" ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} Lib/fontParts/fontshell/test.py
    runHook postCheck
  '';

  meta = {
    description = "API for interacting with the parts of fonts during the font development process";
    homepage = "https://github.com/robotools/fontParts";
    changelog = "https://github.com/robotools/fontParts/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
})
