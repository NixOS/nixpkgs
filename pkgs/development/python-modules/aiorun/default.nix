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
  version = "2024.5.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cjrh";
    repo = "aiorun";
    rev = "refs/tags/v${version}";
    hash = "sha256-7wgsj44sX2Be/QyvG7KgQ/xSgsr+WPh7eeROeICSHGw=";
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
