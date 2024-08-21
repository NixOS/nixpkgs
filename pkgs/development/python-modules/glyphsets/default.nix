{
  lib,
  buildPythonPackage,
  fetchPypi,
  defcon,
  fonttools,
  gflanguages,
  glyphslib,
  pytestCheckHook,
  pyyaml,
  requests,
  setuptools,
  setuptools-scm,
  unicodedata2,
}:

buildPythonPackage rec {
  pname = "glyphsets";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fa+W1IGIZcn1P1xNKm1Yb/TOuf4QdDVnIvlDkOLOcLY=";
  };

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
  ];

  meta = with lib; {
    description = "Google Fonts glyph set metadata";
    mainProgram = "glyphsets";
    homepage = "https://github.com/googlefonts/glyphsets";
    license = licenses.asl20;
    maintainers = with maintainers; [ danc86 ];
  };
}
