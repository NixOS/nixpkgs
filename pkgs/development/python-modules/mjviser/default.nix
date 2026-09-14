{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  mujoco,
  numpy,
  pillow,
  trimesh,
  viser,
  pytest,
  ruff,
  nix-update-script,
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
      --replace-fail '"uv_build>=' '"uv_build"] #'
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

  optional-dependencies = {
    dev = [
      pytest
      ruff
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mjviser"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Web-based MuJoCo viewer powered by Viser";
    homepage = "https://github.com/mujocolab/mjviser";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
