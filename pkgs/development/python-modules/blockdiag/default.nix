{
  lib,
  buildPythonPackage,
  docutils,
  ephem,
  fetchFromGitHub,
  fetchpatch,
  fetchpatch2,
  funcparserlib,
  pillow,
  pytestCheckHook,
  pythonOlder,
  reportlab,
  setuptools,
  webcolors,
}:

buildPythonPackage rec {
  pname = "blockdiag";
  version = "3.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "blockdiag";
    repo = "blockdiag";
    rev = "refs/tags/${version}";
    hash = "sha256-j8FoNUIJJOaahaol1MRPyY2jcPCEIlaAD4bmM2QKFFI=";
  };

  patches = [
    # https://github.com/blockdiag/blockdiag/pull/179
    (fetchpatch {
      name = "pillow-10-compatibility.patch";
      url = "https://github.com/blockdiag/blockdiag/commit/20d780cad84e7b010066cb55f848477957870165.patch";
      hash = "sha256-t1zWFzAsLL2EUa0nD4Eui4Y5AhAZLRmp/yC9QpzzeUA=";
    })
    # https://github.com/blockdiag/blockdiag/pull/175
    (fetchpatch2 {
      name = "migrate-to-pytest.patch";
      url = "https://github.com/blockdiag/blockdiag/commit/4f4f726252084f17ecc6c524592222af09d37da4.patch";
      hash = "sha256-OkfKJwJtb2DJRXE/8thYnisTFwcfstUFTTJHdM/qBzg=";
    })
  ];

  postPatch = ''
    # requires network access the url-based icon
    # and path-based icon is set to debian logo (/usr/share/pixmaps/debian-logo.png)
    rm src/blockdiag/tests/diagrams/node_icon.diag
    # note: this is a postPatch as `seqdiag` uses them directly
  '';

  build-system = [ setuptools ];

  dependencies = [
    docutils
    funcparserlib
    pillow
    reportlab
    webcolors
  ];

  nativeCheckInputs = [
    ephem
    pytestCheckHook
  ];

  pytestFlagsArray = [ "src/blockdiag/tests/" ];

  disabledTests = [
    # Test require network access
    "test_app_cleans_up_images"
    # DeprecationWarning in dependency: reportlab
    "test_align_option_1"
    # Comparison w/ magic values in test
    "test_generate_with_separate"
  ];

  pythonImportsCheck = [ "blockdiag" ];

  meta = with lib; {
    description = "Generate block-diagram image from spec-text file (similar to Graphviz)";
    homepage = "http://blockdiag.com/";
    changelog = "https://github.com/blockdiag/blockdiag/blob/${version}/CHANGES.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ bjornfor ];
    mainProgram = "blockdiag";
    platforms = platforms.unix;
  };
}
