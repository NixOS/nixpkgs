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
  version = "2.11.1";

  src = fetchFromGitHub {
    owner = "JuliaStrings";
    repo = "utf8proc";
    rev = "v${version}";
    hash = "sha256-fFeevzek6Oql+wMmkZXVzKlDh3wZ6AjGCKJFsXBaqzg=";
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

  meta = {
    description = "Clean C library for processing UTF-8 Unicode data";
    homepage = "https://juliastrings.github.io/utf8proc/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [
      lib.maintainers.ftrvxmtrx
      lib.maintainers.sternenseemann
    ];
  };
}
