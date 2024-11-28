{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "xortool";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hellman";
    repo = "xortool";
    rev = "refs/tags/v${version}";
    hash = "sha256-xxaWhGUh/r34eS2TJt8c3Q795OsZOoQLXQllJGJTjqY=";
  };

  build-system = with python3Packages; [ poetry-core ];

  dependencies = with python3Packages; [
    docopt
    importlib-metadata
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "xortool" ];

  meta = with lib; {
    description = "Tool to analyze multi-byte XOR cipher";
    homepage = "https://github.com/hellman/xortool";
    changelog = "https://github.com/hellman/xortool/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
