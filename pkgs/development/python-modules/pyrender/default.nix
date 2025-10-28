{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  freetype-py,
  imageio,
  networkx,
  numpy,
  pillow,
  pyglet,
  pyopengl,
  scipy,
  six,
  trimesh,
  pytestCheckHook,
  mesa,
}:

buildPythonPackage rec {
  pname = "pyrender";
  version = "0.1.45";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "mmatl";
    repo = "pyrender";
    tag = version;
    hash = "sha256-V2G8QWXMxFDQpT4XDOJhIFI2V9VhDQCaXYBb/QVLxgM=";
  };

  patches = [
    (fetchpatch {
      # yet to be tagged
      name = "relax-pyopengl.patch";
      url = "https://github.com/mmatl/pyrender/commit/7c613e8aed7142df9ff40767a8f10b7a19b6255c.patch";
      hash = "sha256-SXRV9RC3PfQGjjIQ+n97HZrSDPae3rAHnTBiHXSFLaY=";
    })
    # fix on numpy 2.0 (np.infty -> np.inf)
    # https://github.com/mmatl/pyrender/pull/292
    (fetchpatch {
      name = "fix-numpy2.patch";
      url = "https://github.com/mmatl/pyrender/commit/5408c7b45261473511d2399ab625efe11f0b6991.patch";
      hash = "sha256-RIv6lMpxMmops5Tb1itzYdT7GkhPScVWslBXITR3IBM=";
    })
  ];

  # trimesh too new
  # issue: https://github.com/mmatl/pyrender/issues/203
  # mega pr: https://github.com/mmatl/pyrender/pull/216
  # relevant pr commit: https://github.com/mmatl/pyrender/pull/216/commits/5069aeb957addff8919f05dc9be4040f55bff329
  # the commit does not apply as a patch when cherry picked, hence the substituteInPlace
  postPatch = ''
    substituteInPlace tests/unit/test_meshes.py \
      --replace-fail \
        "bm = trimesh.load('tests/data/WaterBottle.glb').dump()[0]" \
        'bm = trimesh.load("tests/data/WaterBottle.glb").geometry["WaterBottle"]'
  '';

  nativeBuildInputs = [ setuptools ];

  dependencies = [
    freetype-py
    imageio
    networkx
    numpy
    pillow
    pyglet
    pyopengl
    scipy
    six
    trimesh
  ];

  env.PYOPENGL_PLATFORM = "egl"; # enables headless rendering during check

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.filter (lib.meta.availableOn stdenv.hostPlatform) [
    mesa.llvmpipeHook
  ];

  disabledTestPaths = lib.optionals (!lib.meta.availableOn stdenv.hostPlatform mesa.llvmpipeHook) [
    # requires opengl context
    "tests/unit/test_offscreen.py"
  ];

  pythonImportsCheck = [ "pyrender" ];

  meta = with lib; {
    homepage = "https://pyrender.readthedocs.io/en/latest/";
    description = "Easy-to-use glTF 2.0-compliant OpenGL renderer for visualization of 3D scenes";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
