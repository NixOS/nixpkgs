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
  version = "0.12.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "fontParts";
    inherit version;
    hash = "sha256-eeU13S1IcC+bsiK3YDlT4rVDeXDGcxx1wY/is8t5pCA=";
    extension = "zip";
  };

  patches = [
    (fetchpatch2 {
      # replace remaining usage of assertEquals for Python 3.12 support
      # https://github.com/robotools/fontParts/pull/720
      url = "https://github.com/robotools/fontParts/commit/d7484cd98051aa1588683136da0bb99eac31523b.patch";
      hash = "sha256-maoUgbmXY/RC4TUZI4triA9OIfB4T98qjUaQ94uhsbg=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs =
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
    description = "An API for interacting with the parts of fonts during the font development process.";
    homepage = "https://github.com/robotools/fontParts";
    changelog = "https://github.com/robotools/fontParts/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
