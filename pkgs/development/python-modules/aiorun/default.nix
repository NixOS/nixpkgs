{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  flit-core,
  pygments,
  pytestCheckHook,
  uvloop,
}:

buildPythonPackage rec {
  pname = "aiorun";
  version = "2025.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cjrh";
    repo = "aiorun";
    tag = "v${version}";
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

  meta = with lib; {
    description = "Boilerplate for asyncio applications";
    homepage = "https://github.com/cjrh/aiorun";
    changelog = "https://github.com/cjrh/aiorun/blob/v${version}/CHANGES";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
