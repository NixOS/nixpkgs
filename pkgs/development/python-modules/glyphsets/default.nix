{
  lib,
  buildPythonPackage,
  defcon,
  fetchPypi,
  fonttools,
  gflanguages,
  glyphslib,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  requests,
  setuptools-scm,
  setuptools,
  tabulate,
  unicodedata2,
  youseedee,
}:

buildPythonPackage rec {
  pname = "glyphsets";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jza6VQ3PZAQPku2hyo0KeO59r64Q9TpqLCI0dIX/URU=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "setuptools_scm>=8.1.0,<8.2" setuptools_scm
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

  meta = with lib; {
    description = "Google Fonts glyph set metadata";
    homepage = "https://github.com/googlefonts/glyphsets";
    changelog = "https://github.com/googlefonts/glyphsets/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ danc86 ];
    mainProgram = "glyphsets";
  };
}
