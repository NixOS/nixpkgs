{
  lib,
  buildPythonPackage,
  defcon,
  fetchPypi,
  fonttools,
  gflanguages,
  glyphslib,
  pytestCheckHook,
  pyyaml,
  requests,
  setuptools-scm,
  setuptools,
  tabulate,
  unicodedata2,
  youseedee,
}:

buildPythonPackage (finalAttrs: {
  pname = "glyphsets";
  version = "1.1.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-YJ5hNq2QgIgQFnMJ+yJGOzsLRpUabSqJttVEWsRDBaQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools_scm[toml]>=8.1.0,<8.2" "setuptools_scm"
  '';

  env.PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    defcon
    fonttools
    gflanguages
    glyphslib
    pyyaml
    requests
    tabulate
    unicodedata2
    youseedee
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  disabledTests = [
    # This "test" just tries to connect to PyPI and look for newer releases. Not needed.
    "test_dependencies"
    # 616 instead of 617 glyphs in a glyphset
    "test_definitions"
  ];

  meta = {
    description = "Google Fonts glyph set metadata";
    homepage = "https://github.com/googlefonts/glyphsets";
    changelog = "https://github.com/googlefonts/glyphsets/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ danc86 ];
    mainProgram = "glyphsets";
  };
})
