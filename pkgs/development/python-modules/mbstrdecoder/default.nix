{ buildPythonPackage
, fetchFromGitHub
, lib
, chardet
, pytestCheckHook
, faker
}:

buildPythonPackage rec {
  pname = "mbstrdecoder";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-U8F+mWKDulIRvvhswmdGnxKjM2qONQybViQ5TLZbLDY=";
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
