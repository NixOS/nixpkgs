{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch
, freetype-py
, imageio
, networkx
, numpy
, pillow
, pyglet
, pyopengl
, scipy
, six
, trimesh
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyrender";
  version = "0.1.45";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "mmatl";
    repo = "pyrender";
    rev = "refs/tags/${version}";
    hash = "sha256-V2G8QWXMxFDQpT4XDOJhIFI2V9VhDQCaXYBb/QVLxgM=";
  };

  patches = [
    (fetchpatch { # yet to be tagged
      name = "relax-pyopengl.patch";
      url = "https://github.com/mmatl/pyrender/commit/7c613e8aed7142df9ff40767a8f10b7a19b6255c.patch";
      hash = "sha256-SXRV9RC3PfQGjjIQ+n97HZrSDPae3rAHnTBiHXSFLaY=";
    })
  ];

  # trimesh too new
  # issue: https://github.com/mmatl/pyrender/issues/203
  # mega pr: https://github.com/mmatl/pyrender/pull/216
  # relevant pr commit: https://github.com/mmatl/pyrender/pull/216/commits/5069aeb957addff8919f05dc9be4040f55bff329
  # the commit does not apply as a patch when cherry picked, hence the substituteInPlace
  postPatch = ''
    substituteInPlace tests/unit/test_meshes.py \
      --replace \
        "bm = trimesh.load('tests/data/WaterBottle.glb').dump()[0]" \
        'bm = trimesh.load("tests/data/WaterBottle.glb").geometry["WaterBottle"]'
  '';

  propagatedBuildInputs = [
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
  ];

  disabledTestPaths = [
    # does not work inside sandbox, no GPU
    "tests/unit/test_offscreen.py"
  ];

  pythonImportsCheck = [ "pyrender" ];

  meta = with lib; {
    homepage = "https://pyrender.readthedocs.io/en/latest/";
    description = "Easy-to-use glTF 2.0-compliant OpenGL renderer for visualization of 3D scenes";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}
