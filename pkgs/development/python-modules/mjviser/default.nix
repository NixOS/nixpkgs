{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,

  # dependencies
  mujoco,
  numpy,
  pillow,
  trimesh,
  viser,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mjviser";
  version = "0.0.14";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mujocolab";
    repo = "mjviser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LzltAgWKK84gQU4IlzKv7SClaUrLCdyU8vzHh4LIqDs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        "uv_build>=0.8.19,<0.9.0" \
        "uv_build"
  '';

  build-system = [
    uv-build
  ];

  dependencies = [
    mujoco
    numpy
    pillow
    trimesh
    viser
  ];

  pythonImportsCheck = [ "mjviser" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Web-based MuJoCo viewer powered by Viser";
    homepage = "https://github.com/mujocolab/mjviser";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
