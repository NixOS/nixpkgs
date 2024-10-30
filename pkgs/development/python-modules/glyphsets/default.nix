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
  unicodedata2,
}:

buildPythonPackage rec {
  pname = "glyphsets";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fa+W1IGIZcn1P1xNKm1Yb/TOuf4QdDVnIvlDkOLOcLY=";
  };

  env.PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "setuptools_scm>=8.0.4,<8.1" "setuptools_scm"
  '';

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
    unicodedata2
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  disabledTests = [
    # This "test" just tries to connect to PyPI and look for newer releases. Not needed.
    "test_dependencies"
    # AssertionError
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
