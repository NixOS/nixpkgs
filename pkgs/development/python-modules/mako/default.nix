{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
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
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sqlalchemy";
    repo = "mako";
    tag = "rel_${lib.replaceString "." "_" finalAttrs.version}";
    hash = "sha256-vVjCn1UaxflEiWp1GRra1aU7GUVGDvIgRXt5E4+lESU=";
  };

  patches = [
    # https://github.com/sqlalchemy/mako/issues/440
    (fetchpatch2 {
      name = "pygments-2.21.0-compat.patch";
      url = "https://github.com/sqlalchemy/mako/commit/411b4ac6cf054e61a8fb44c236990fda1e41ade4.patch?full_index=1";
      hash = "sha256-dQk3Qmi42rwX6ZTYXycict21ZcRJC4dPQaSTg8Vjzug=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'tag-build = "dev"' ""
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

  disabledTests = [
    # AssertionError
    "test_py_utf8_html_error_template"
    "test_utf8_format_exceptions_pygments"
    "test_custom_tback"
  ]
  ++ lib.optionals isPyPy [
    # https://github.com/sqlalchemy/mako/issues/315
    "test_alternating_file_names"
    # https://github.com/sqlalchemy/mako/issues/238
    "test_file_success"
    "test_stdin_success"
    # fails on pypy2.7
    "test_bytestring_passthru"
  ];

  pythonImportsCheck = [ "mako" ];

  meta = {
    description = "Super-fast templating language";
    homepage = "https://www.makotemplates.org/";
    changelog = "https://github.com/sqlalchemy/mako/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "mako-render";
    platforms = lib.platforms.unix;
  };
})
