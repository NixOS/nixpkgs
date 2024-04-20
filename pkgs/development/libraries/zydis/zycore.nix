{ stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "zycore";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "zyantific";
    repo = "zycore-c";
    rev = "v${version}";
    hash = "sha256-Kz51EIaw4RwrOKXhuDXAFieGF1mS+HL06gEuj+cVJmk=";
  };

  nativeBuildInputs = [ cmake ];

  # The absolute paths set by the Nix CMake build manager confuse
  # Zycore's config generation (which appends them to the package path).
  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];
}
