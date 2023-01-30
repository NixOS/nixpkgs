{ buildPythonPackage, fetchFromGitHub, pytestCheckHook, lib }:

buildPythonPackage rec {
  pname = "leb128";
  version = "1.0.4";

  # fetchPypi doesn't include files required for tests
  src = fetchFromGitHub {
    owner = "mohanson";
    repo = "leb128";
    rev = "v${version}";
    sha256 = "040l6fxyzqal841kirf783kk1840gcy1gjd374jfr46v96qc8scm";
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
