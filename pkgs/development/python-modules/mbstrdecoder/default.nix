{ buildPythonPackage
, chardet

, fetchFromGitHub
, lib
}:

buildPythonPackage rec {
  pname = "mbstrdecoder";
  version = "1.1.1";

  propagatedBuildInputs = [ chardet ];
  doCheck = false;

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-U8F+mWKDulIRvvhswmdGnxKjM2qONQybViQ5TLZbLDY=";
  };

  meta = with lib; {
    homepage = "https://github.com/thombashi/mbstrdecoder";
    description = "mbstrdecoder is a Python library for multi-byte character string decoder";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.mit;
  };
}
