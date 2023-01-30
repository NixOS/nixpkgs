{ lib, stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation rec {
  pname = "tongsuo";
  version = "8.3.2";

  src = fetchFromGitHub {
    owner = "Tongsuo-Project";
    repo = "Tongsuo";
    rev = version;
    sha256 = "sha256-sUAhDBGEBbWdS3B+bKx+CFYgOcwsO97j/LpU9q68QIg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ perl ];

  configureScript = "sh config";

  meta = with lib; {
    description = "A Modern Cryptographic Primitives and Protocols Library";
    homepage = "https://www.tongsuo.net";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ candyc1oud ];
  };
}
