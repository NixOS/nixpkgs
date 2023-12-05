{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "valijson";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "tristanpenman";
    repo = "valijson";
    rev = "v${version}";
    hash = "sha256-COVFBZtuTd1nyI/25feUYCurBwPlQV3qbxSSkn6aLl4=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "Header-only C++ library for JSON Schema validation, with support for many popular parsers";
    homepage = "https://github.com/tristanpenman/valijson";
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
