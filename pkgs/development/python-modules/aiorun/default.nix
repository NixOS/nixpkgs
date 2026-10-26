{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pygments,
  pytestCheckHook,
  uvloop,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiorun";
  version = "2025.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cjrh";
    repo = "aiorun";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YqUlWf79EbC47BETBDjo8hzg5jhL4LiWLKGr1Qy4AbM=";
  };

  build-system = [ flit-core ];

  dependencies = [ pygments ];

  nativeCheckInputs = [
    pytestCheckHook
    uvloop
  ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [ "aiorun" ];

  meta = {
    description = "Boilerplate for asyncio applications";
    homepage = "https://github.com/cjrh/aiorun";
    changelog = "https://github.com/cjrh/aiorun/blob/v${finalAttrs.version}/CHANGES";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
