{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "tinycbor";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "tinycbor";
    rev = "v${version}";
    sha256 = "sha256-H0NTUaSOGMtbM1+EQVOsYoPP+A1FGvUM7XrbPxArR88=";
  };

  makeFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    description = "Concise Binary Object Representation (CBOR) Library";
    homepage = "https://github.com/intel/tinycbor";
    license = licenses.mit;
    maintainers = with maintainers; [ oxzi ];
  };
}
