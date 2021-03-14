{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "tinycbor";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "tinycbor";
    rev = "v${version}";
    sha256 = "11y6liyd3fvc28d3dinii16sxgwgg2p29p41snc4h82dvvx5bb2b";
  };

  makeFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    description = "Concise Binary Object Representation (CBOR) Library";
    homepage = "https://github.com/intel/tinycbor";
    license = licenses.mit;
    maintainers = with maintainers; [ oxzi ];
  };
}
