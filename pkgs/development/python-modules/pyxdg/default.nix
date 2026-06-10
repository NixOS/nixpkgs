{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  fetchpatch2,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyxdg";
  version = "0.28";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "xdg";
    repo = "pyxdg";
    tag = "rel-${finalAttrs.version}";
    hash = "sha256-TrFQzfkXabmfpGYwhxD1UVY1F645KycfSPPrMJFAe+0=";
  };

  patches = [
    (fetchpatch2 {
      name = "python314-ast.diff";
      url = "https://gitlab.freedesktop.org/xdg/pyxdg/-/commit/9291d419017263c922869d79ac1fe8d423e5f929.diff";
      sha256 = "sha256-sFChDLwBvJWkZES7mZszVChmwCuc9+oAi9fMUcwF298=";
    })
  ];

  postPatch = ''
    substituteInPlace test/test_basedirectory.py \
      --replace-fail "from imp import reload" "from importlib import reload"
  '';

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Disable tests doing MIME type lookups, as those are not installed in the build environment
  disabledTests = [
    "test_by_name"
    "test_canonical"
    "test_get_type"
    "test_get_type2"
    "test_get_type_by_contents"
    "test_get_type_by_data"
    "test_get_type_by_name"
    "test_inheritance"
  ];

  pythonImportsCheck = [ "xdg" ];

  meta = {
    homepage = "http://freedesktop.org/wiki/Software/pyxdg";
    description = "Contains implementations of freedesktop.org standards";
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ ambossmann ];
  };
})
