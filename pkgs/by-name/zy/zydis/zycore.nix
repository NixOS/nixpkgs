{
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "zycore";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "zyantific";
    repo = "zycore-c";
    rev = "v${version}";
    hash = "sha256-/RQl43gx3CO0OxH1syz4l3E4+/m46ql+HKVyuC1x4sA=";
  };

  nativeBuildInputs = [ cmake ];

  # The absolute paths set by the Nix CMake build manager confuse
  # Zycore's config generation (which appends them to the package path).
  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];
}
