{ buildPythonPackage
, fetchFromGitHub
, lib
, chardet
, pytestCheckHook
, faker
}:

buildPythonPackage rec {
  pname = "mbstrdecoder";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-vLlCS5gnc7NgDN4cEZSxxInzbEq4HXAXmvlVfwn3cSM=";
  };

  propagatedBuildInputs = [ chardet ];

  nativeCheckInputs = [ pytestCheckHook ];
  checkInputs = [ faker ];

  meta = with lib; {
    homepage = "https://github.com/thombashi/mbstrdecoder";
    description = "A library for decoding multi-byte character strings";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.mit;
  };
}
