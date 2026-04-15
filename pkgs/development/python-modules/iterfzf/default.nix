{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  fzf,
  packaging,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "iterfzf";
  version = "1.9.0.67.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dahlia";
    repo = "iterfzf";
    tag = finalAttrs.version;
    hash = "sha256-Giw5d0X8/1PXK1j428LJjg+Gqadm93C51mLfrYc5J94=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'dynamic = ["version"]' 'version = "${finalAttrs.version}"' \
      --replace-fail 'backend-path = ["."]' '# backend-path = ["."]' \
      --replace-fail 'build-backend = "build_dist"' '# build-backend = "build_dist"'

    substituteInPlace iterfzf/test_iterfzf.py \
      --replace-fail 'executable="fzf"' 'executable="${fzf}/bin/fzf"'
  '';

  build-system = [
    flit-core
    setuptools
    packaging
  ];

  dependencies = [ fzf ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # AttributeError
    "test_no_query"
    "test_select_one_ambiguous"
    "test_supports_color_kwarg"
  ];

  pythonImportsCheck = [ "iterfzf" ];

  meta = {
    description = "Pythonic interface to fzf, a CLI fuzzy finder";
    homepage = "https://github.com/dahlia/iterfzf";
    changelog = "https://github.com/dahlia/iterfzf/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.unix;
  };
})
