{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "tinycbor";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "tinycbor";
    rev = "v${version}";
    sha256 = "1ph1cmsh4hm6ikd3bs45mnv9zmniyrvp2rrg8qln204kr6fngfcd";
  };

  makeFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    description = "Concise Binary Object Representation (CBOR) Library";
    mainProgram = "cbordump";
    homepage = "https://github.com/intel/tinycbor";
    license = licenses.mit;
    maintainers = with maintainers; [ oxzi ];
  };
}
