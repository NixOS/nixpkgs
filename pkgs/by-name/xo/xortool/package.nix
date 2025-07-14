{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "xortool";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hellman";
    repo = "xortool";
    tag = "v${version}";
    hash = "sha256-KakpXRhBVgUtIiqqvq30u7sIIeXe9vr5aqndOb0cR64=";
  };

  build-system = with python3Packages; [ poetry-core ];

  dependencies = with python3Packages; [
    docopt
    importlib-metadata
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "xortool" ];

  meta = {
    description = "Tool to analyze multi-byte XOR cipher";
    homepage = "https://github.com/hellman/xortool";
    changelog = "https://github.com/hellman/xortool/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
