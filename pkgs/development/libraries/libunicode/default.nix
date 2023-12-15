{ lib, stdenv, fetchFromGitHub, fetchzip, cmake, catch2, fmt, python3 }:

let
  ucd-version = "15.0.0";

  ucd-src = fetchzip {
    url = "https://www.unicode.org/Public/${ucd-version}/ucd/UCD.zip";
    hash = "sha256-jj6bX46VcnH7vpc9GwM9gArG+hSPbOGL6E4SaVd0s60=";
    stripRoot = false;
  };
in stdenv.mkDerivation (final: {
  pname = "libunicode";
  version = "0.3.0-unstable-2023-03-05";

  src = fetchFromGitHub {
    owner = "contour-terminal";
    repo = "libunicode";
    rev = "65e0c6ddf9648b94aa9bc7dda0718401efa9ef8e";
    hash = "sha256-F4CVU5MImkM571mD4iFxqTnNbk2GXKTGksqO4LH2uEk=";
  };

  nativeBuildInputs = [ cmake python3 ];
  buildInputs = [ catch2 fmt ];

  cmakeFlags = [ "-DLIBUNICODE_UCD_DIR=${ucd-src}" ];

  meta = with lib; {
    description = "Modern C++17 Unicode library";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ moni ];
  };
})
