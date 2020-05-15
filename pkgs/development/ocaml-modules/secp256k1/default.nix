{ stdenv, fetchFromGitHub, buildDunePackage, base, stdio, configurator, secp256k1 }:

buildDunePackage {
  pname = "secp256k1";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "dakk";
    repo = "secp256k1-ml";
    rev = "42c04c93e2ed9596f6378676e944c8cfabfa69d7";
    sha256 = "1zw2kgg181a9lj1m8z0ybijs8gw9w1kk990avh1bp9x8kc1asffg";
  };

  buildInputs = [ base stdio configurator secp256k1 ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/dakk/secp256k1-ml";
    description = "Elliptic curve library secp256k1 wrapper for Ocaml";
    license = licenses.mit;
    maintainers = [ maintainers.vyorkin ];
  };
}
