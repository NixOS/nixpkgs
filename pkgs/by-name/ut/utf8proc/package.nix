{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  # passthru.tests
  tmux,
  fcft,
  arrow-cpp,
}:

stdenv.mkDerivation rec {
  pname = "utf8proc";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "JuliaStrings";
    repo = "utf8proc";
    rev = "v${version}";
    hash = "sha256-iNITnxA1cacOBRU/XV22yzjB0XUOCYsaLLLPYLa+AoA=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DUTF8PROC_ENABLE_TESTING=ON"
  ];

  doCheck = true;

  passthru.tests = {
    inherit fcft tmux arrow-cpp;
  };

  meta = with lib; {
    description = "Clean C library for processing UTF-8 Unicode data";
    homepage = "https://juliastrings.github.io/utf8proc/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [
      maintainers.ftrvxmtrx
      maintainers.sternenseemann
    ];
  };
}
