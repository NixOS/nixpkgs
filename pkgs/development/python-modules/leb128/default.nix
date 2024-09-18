{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  lib,
}:

buildPythonPackage rec {
  pname = "leb128";
  version = "1.0.8";
  pyproject = true;

  # fetchPypi doesn't include files required for tests
  src = fetchFromGitHub {
    owner = "mohanson";
    repo = "leb128";
    rev = "refs/tags/v${version}";
    hash = "sha256-7ZjDqxGUANk3FfB3HPTc5CB5YcIi2ee0igXWAYXaZ88=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "leb128" ];

  meta = with lib; {
    changelog = "https://github.com/mohanson/leb128/releases/tag/v${version}";
    description = "Utility to encode and decode Little Endian Base 128";
    homepage = "https://github.com/mohanson/leb128";
    license = licenses.mit;
    maintainers = with maintainers; [ urlordjames ];
  };
}
