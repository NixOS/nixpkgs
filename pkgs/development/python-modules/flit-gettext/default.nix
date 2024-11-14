{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  substituteAll,

  # build-system
  flit-scm,
  wheel,

  # dependencies
  flit-core,
  gettext,

  # tests
  build,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flit-gettext";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "codingjoe";
    repo = "flit-gettext";
    rev = version;
    hash = "sha256-YsRfpciSrHmivEJKfzdp6UaPx2tSr3VdjU4ZIbYQX6c=";
  };

  patches = [
    (substituteAll {
      src = ./msgfmt-path.patch;
      msgfmt = lib.getExe' gettext "msgfmt";
    })
  ];

  postPatch = ''
    sed -i "s/--cov//" pyproject.toml
  '';

  nativeBuildInputs = [
    flit-scm
    wheel
  ];

  propagatedBuildInputs = [ flit-core ];

  optional-dependencies = {
    scm = [ flit-scm ];
  };

  nativeCheckInputs = [
    build
    pytestCheckHook
    wheel
  ] ++ optional-dependencies.scm;

  disabledTests = [
    # tests for missing msgfmt, but we always provide it
    "test_compile_gettext_translations__no_gettext"
  ];

  disabledTestPaths = [
    # calls python -m build, but can't find build
    "tests/test_core.py"
    "tests/test_scm.py"
  ];

  pythonImportsCheck = [ "flit_gettext" ];

  meta = with lib; {
    description = "Compiling gettext i18n messages during project bundling";
    homepage = "https://github.com/codingjoe/flit-gettext";
    license = licenses.bsd2;
    maintainers = with maintainers; [ hexa ];
  };
}
