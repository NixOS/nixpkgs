{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  django,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-npm-mjs";
  version = "4.1.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fiduswriter";
    repo = "django-npm-mjs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KkJmze/KWALURamfiM2P+sIi7xaz8izEUqxCEf+jONo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=82.0.1" "setuptools"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    django
  ];

  pythonImportsCheck = [
    "npm_mjs"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Django package to take care of npm.js ES2016+ dependencies";
    homepage = "https://github.com/fiduswriter/django-npm-mjs";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
