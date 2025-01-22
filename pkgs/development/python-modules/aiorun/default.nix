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
  version = "2024.8.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cjrh";
    repo = "aiorun";
    tag = "v${version}";
    hash = "sha256-D+4IceCdPg1Akq1YgPuSGF7yAOhDe8PmioNBE5X7yuQ=";
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
