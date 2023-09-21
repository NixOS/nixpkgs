{ buildPythonPackage, fetchFromGitHub, pytestCheckHook, lib }:

buildPythonPackage rec {
  pname = "leb128";
  version = "1.0.5";

  # fetchPypi doesn't include files required for tests
  src = fetchFromGitHub {
    owner = "mohanson";
    repo = "leb128";
    rev = "refs/tags/v${version}";
    hash = "sha256-zK14LPziBkvXAMzuPbcg/47caO/5GEYA9txAzCGfpS8=";
  };

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "leb128" ];

  meta = with lib; {
    description = "A utility to encode and decode Little Endian Base 128";
    homepage = "https://github.com/mohanson/leb128";
    license = licenses.mit;
    maintainers = with maintainers; [ urlordjames ];
  };
}
