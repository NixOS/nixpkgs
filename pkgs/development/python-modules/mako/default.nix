{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPyPy,

  # build-system
  setuptools_80,

  # propagates
  markupsafe,

  # optional-dependencies
  babel,
  lingua,

  # tests
  chameleon,
  mock,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mako";
  version = "1.3.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sqlalchemy";
    repo = "mako";
    tag = "rel_${lib.replaceString "." "_" finalAttrs.version}";
    hash = "sha256-YIMmP8CIGUlgnB8/96lR9yDvEZTES766dSN0vT0JfbM=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "tag_build = dev" ""
  '';

  build-system = [ setuptools_80 ];

  dependencies = [ markupsafe ];

  optional-dependencies = {
    babel = [ babel ];
    lingua = [ lingua ];
  };

  nativeCheckInputs = [
    chameleon
    mock
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTests = lib.optionals isPyPy [
    # https://github.com/sqlalchemy/mako/issues/315
    "test_alternating_file_names"
    # https://github.com/sqlalchemy/mako/issues/238
    "test_file_success"
    "test_stdin_success"
    # fails on pypy2.7
    "test_bytestring_passthru"
  ];

  meta = {
    changelog = "https://github.com/sqlalchemy/mako/releases/tag/${finalAttrs.src.tag}";
    description = "Super-fast templating language";
    mainProgram = "mako-render";
    homepage = "https://www.makotemplates.org/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
