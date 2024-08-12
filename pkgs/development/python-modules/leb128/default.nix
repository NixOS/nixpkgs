{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  lib,
}:

buildPythonPackage rec {
  pname = "leb128";
  version = "1.0.7";
  pyproject = true;

  # fetchPypi doesn't include files required for tests
  src = fetchFromGitHub {
    owner = "mohanson";
    repo = "leb128";
    rev = "refs/tags/v${version}";
    hash = "sha256-17C0Eic8T2PFkuIGExcrfb3b1HldaSBAPSh5TtRBUuU=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "leb128" ];

  meta = with lib; {
    description = "Utility to encode and decode Little Endian Base 128";
    homepage = "https://github.com/mohanson/leb128";
    license = licenses.mit;
    maintainers = with maintainers; [ urlordjames ];
  };
}
