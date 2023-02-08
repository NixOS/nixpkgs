{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "libdeflate";
  version = "1.17";

  src = fetchFromGitHub {
    owner = "ebiggers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-tKs8feGbeodOID8FPIUc/1LfBz1p0oN1Jfkv2OnA2qc=";
  };

  nativeBuildInputs = [ cmake ];

  outputs = [ "bin" "dev" "out" ];
}
