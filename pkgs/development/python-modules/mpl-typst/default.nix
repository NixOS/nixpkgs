{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  matplotlib,
  numpy,
  pytestCheckHook,
  pillow,
  nix-update-script,
  typst,
}:

buildPythonPackage rec {
  pname = "mpl-typst";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "daskol";
    repo = "mpl-typst";
    tag = "v${version}";
    hash = "sha256-lkO4BTo3duNAsppTjteeBuzgSJL/UnKVW2QXgrfVrqM=";
  };

  postPatch = ''
    # make hermetic
    substituteInPlace mpl_typst/config.py \
      --replace-fail \
        "get_typst_compiler(name: str, default=Path('typst'))" \
        "get_typst_compiler(name: str, default=Path('${lib.getExe typst}'))"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    matplotlib
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pillow
    numpy
  ];

  pytestFlagsArray = [ "-v" ];

  pythonImportsCheck = [
    "mpl_typst"
    "mpl_typst.as_default"
  ];

  disabledTests = [
    # runs typst and gets "error: failed to download package"
    "test_draw_path"
    "test_draw_image_lenna"
    "test_draw_image_spy"
  ];

  disabledTestPaths = lib.optional stdenv.hostPlatform.isDarwin [
    # fatal error when matplotlib creates a canvas
    "mpl_typst/backend_test.py"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Typst backend for matplotlib";
    homepage = "https://github.com/daskol/mpl-typst";
    changelog = "https://github.com/daskol/mpl-typst/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
  };
}
