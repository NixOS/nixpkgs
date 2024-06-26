{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  cmake,
  catch2,
  fmt,
  python3,
}:

let
  ucd-version = "15.0.0";

  ucd-src = fetchzip {
    url = "https://www.unicode.org/Public/${ucd-version}/ucd/UCD.zip";
    hash = "sha256-jj6bX46VcnH7vpc9GwM9gArG+hSPbOGL6E4SaVd0s60=";
    stripRoot = false;
  };
in
stdenv.mkDerivation (final: {
  pname = "libunicode";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "contour-terminal";
    repo = "libunicode";
    rev = "v${final.version}";
    hash = "sha256-Us3T4fnGsArdsVB7IUhwdex43C+H1+lfL8yK9enhf2c=";
  };

  # Fix: set_target_properties Can not find target to add properties to: Catch2, et al.
  patches = [ ./remove-target-properties.diff ];

  nativeBuildInputs = [
    cmake
    python3
  ];
  buildInputs = [
    catch2
    fmt
  ];

  cmakeFlags = [ "-DLIBUNICODE_UCD_DIR=${ucd-src}" ];

  meta = with lib; {
    description = "Modern C++17 Unicode library";
    mainProgram = "unicode-query";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ moni ];
  };
})
