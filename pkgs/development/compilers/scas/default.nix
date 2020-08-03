{ fetchFromGitHub, stdenv, cmake }:


stdenv.mkDerivation rec {
  pname = "scas";
  
  version = "0.4.6";
  
  src = fetchFromGitHub {
    owner = "KnightOS";
    repo = "scas";
    rev = version;
    sha256 = "1c6s9nivbwgv0f8n7j73h54ydgqw5dcpq8l752dfrnqg3kv3nn0h";
  };
  
  nativeBuildInputs = [ cmake ];
  
  hardeningDisable = [ "format" ];
  
  meta = with stdenv.lib; {
    homepage    = "https://knightos.org/";
    description = "Assembler and linker for the Z80.";
    license     = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
